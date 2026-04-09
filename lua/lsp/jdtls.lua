local system = require "utils.system"

local java_ext = system.is_windows() and ".exe" or ""
local resolved_java = nil
local jdtls_root = vim.fs.joinpath(vim.fn.stdpath "data", "mason", "packages", "jdtls")
local maven_settings = vim.fs.joinpath(vim.uv.os_homedir(), ".m2", "settings.xml")

local function add(candidates, value)
    if value and value ~= "" then
        table.insert(candidates, value)
    end
end

local function java_in(home)
    if not home or home == "" then return nil end
    return vim.fs.joinpath(home, "bin", "java" .. java_ext)
end

local function java_major(java)
    if not java or not system.is_executable(java) then return nil end

    local result = vim.system({ java, "-version" }, { text = true }):wait()
    if result.code ~= 0 then return nil end

    local output = (result.stdout or "") .. "\n" .. (result.stderr or "")
    return tonumber(output:match 'version "?(%d+)')
end

local function resolve_java()
    if resolved_java ~= nil then
        return resolved_java or nil
    end

    local candidates = {}
    local home = vim.uv.os_homedir()
    local sdkman_dir = os.getenv "SDKMAN_CANDIDATES_DIR"

    add(candidates, os.getenv "JDTLS_JAVA_EXECUTABLE")
    add(candidates, java_in(os.getenv "JDTLS_JAVA_HOME"))
    add(candidates, java_in(os.getenv "JAVA_HOME"))

    if (not sdkman_dir or sdkman_dir == "") and home then
        sdkman_dir = vim.fs.joinpath(home, ".sdkman", "candidates")
    end

    if sdkman_dir then
        add(candidates, vim.fs.joinpath(sdkman_dir, "java", "current", "bin", "java" .. java_ext))
        vim.list_extend(candidates,
            vim.fn.glob(vim.fs.joinpath(sdkman_dir, "java", "*", "bin", "java" .. java_ext), false, true))
    end

    add(candidates, vim.fn.exepath "java")

    for _, java in ipairs(candidates) do
        if (java_major(java) or 0) >= 21 then
            resolved_java = java
            return java
        end
    end

    resolved_java = false
    return nil
end

local function resolve_jdtls_paths()
    local config_dir
    if system.is_windows() then
        config_dir = "config_win"
    elseif vim.fn.has "macunix" == 1 then
        config_dir = "config_mac"
    else
        config_dir = "config_linux"
    end

    local launcher = vim.fn.glob(vim.fs.joinpath(jdtls_root, "plugins", "org.eclipse.equinox.launcher_*.jar"), false,
        true)[1]
    if not launcher or launcher == "" then
        launcher = vim.fs.joinpath(jdtls_root, "plugins", "org.eclipse.equinox.launcher.jar")
    end

    if not vim.uv.fs_stat(launcher) then return nil end

    return {
        launcher = launcher,
        config = vim.fs.joinpath(jdtls_root, config_dir),
    }
end

local function resolve_lombok(project_root)
    local home = vim.uv.os_homedir()
    if home and project_root then
        for _, factorypath in ipairs(vim.fn.globpath(project_root, "**/.factorypath", false, true)) do
            for _, line in ipairs(vim.fn.readfile(factorypath)) do
                local repo_path = line:match 'M2_REPO/([^"]+/lombok%-%d[%w%._%-]*%.jar)'
                if repo_path then
                    local jar = vim.fs.joinpath(home, ".m2", "repository", repo_path)
                    if vim.uv.fs_stat(jar) then
                        return jar
                    end
                end
            end
        end
    end

    local candidates = {
        os.getenv "JDTLS_LOMBOK_JAR",
        vim.fs.joinpath(vim.fn.stdpath "data", "mason", "packages", "jdtls", "lombok.jar"),
        vim.fs.joinpath(vim.fn.stdpath "data", "mason", "share", "jdtls", "lombok.jar"),
    }

    for _, jar in ipairs(candidates) do
        if jar and jar ~= "" and vim.uv.fs_stat(jar) then
            return jar
        end
    end

    return nil
end

local function root_dir(bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local git_root = vim.fs.root(fname, ".git")

    if git_root and vim.uv.fs_stat(vim.fs.joinpath(git_root, "pom.xml")) then
        return git_root
    end

    return vim.fs.root(fname, {
        "gradlew",
        "mvnw",
        "pom.xml",
        "build.gradle",
        "build.gradle.kts",
        "settings.gradle",
        "settings.gradle.kts",
        ".git",
    })
end

local function workspace_dir(project_root)
    local name = vim.fs.basename(project_root)
    if not name or name == "" then
        name = "workspace"
    end

    name = name:gsub("[^%w_.-]", "_")
    local dir = vim.fs.joinpath(vim.fn.stdpath "cache", "jdtls", name .. "-" .. vim.fn.sha256(project_root):sub(1, 12))
    vim.fn.mkdir(dir, "p")
    return dir
end

local function capabilities()
    local caps = vim.lsp.protocol.make_client_capabilities()
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
        caps = cmp_nvim_lsp.default_capabilities(caps)
    end
    return caps
end

local function cmd(project_root)
    local java = resolve_java()
    if not java then
        vim.schedule(function()
            vim.notify(
                "jdtls requires Java 21+. Set JDTLS_JAVA_HOME, JDTLS_JAVA_EXECUTABLE, or JAVA_HOME.",
                vim.log.levels.WARN
            )
        end)
        return nil
    end

    local paths = resolve_jdtls_paths()
    if not paths then
        vim.schedule(function()
            vim.notify("Unable to locate eclipse.jdt.ls launcher jar.", vim.log.levels.WARN)
        end)
        return nil
    end

    local command = {
        java,
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dosgi.checkConfiguration=true",
        "-Dosgi.sharedConfiguration.area=" .. paths.config,
        "-Dosgi.sharedConfiguration.area.readOnly=true",
        "-Dosgi.configuration.cascaded=true",
        "-Xms1G",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
    }

    local lombok = resolve_lombok(project_root)
    if lombok then
        table.insert(command, "-javaagent:" .. lombok .. "=ECJ")
    end

    vim.list_extend(command, {
        "-jar",
        paths.launcher,
        "-data",
        workspace_dir(project_root),
    })

    return command
end

local function config(bufnr)
    local project_root = root_dir(bufnr)
    if not project_root then return nil end

    return {
        name = "jdtls",
        cmd = cmd(project_root),
        root_dir = project_root,
        capabilities = capabilities(),
        init_options = { bundles = {} },
        on_attach = function(client, attach_bufnr)
            client.server_capabilities.inlayHintProvider = nil
            if vim.lsp.inlay_hint then
                vim.lsp.inlay_hint.enable(false, { bufnr = attach_bufnr })
            end
        end,
        settings = {
            java = {
                configuration = {
                    maven = vim.uv.fs_stat(maven_settings) and {
                        userSettings = maven_settings,
                    } or nil,
                },
                maven = {
                    updateSnapshots = true,
                },
                jdt = {
                    ls = {
                        lombokSupport = {
                            enabled = false,
                        },
                    },
                },
            },
        },
    }
end

local function start_or_attach(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].filetype ~= "java" then return end

    local jdtls_config = config(bufnr)
    if not jdtls_config or not jdtls_config.cmd then return end

    require "jdtls".start_or_attach(jdtls_config)
end

local group = vim.api.nvim_create_augroup("nvim-jdtls", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "java",
    callback = function(args)
        start_or_attach(args.buf)
    end,
})

start_or_attach()
