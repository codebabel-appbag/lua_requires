-- =====================================================================
-- Requires Loader v9 (Hardened, Type-Checked & Clean Error Reporting++)
-- =====================================================================

local function colorize(text, color_code)
    return string.format("\27[%dm%s\27[0m", color_code, text)
end

local function print_critical_error(msg)
    io.stderr:write(colorize("[requires] Critical failure loading dependencies:", 31) .. "\n")
    io.stderr:write(colorize("  - " .. msg, 31) .. "\n")
    os.exit(1)
end

local function sanitize_error_message(err)
    -- Remove caminhos absolutos genéricos e arquivos .so ou .lua das mensagens de erro
    local clean_err = err:gsub("/[%w%-_./]+%.%w+", "[path-hidden]")
                         :gsub("%a:[/\\][%w%-_./\\]+%.%w+", "[path-hidden]")
                         :gsub("[^%s]+[/\\]%?[^%s]*", "[internal-path]")
    return clean_err
end

local function hardened_requires(...)
    local args = { ... }
    local loaded_modules = {}

    for _, mod in ipairs(args) do
        -- 1. Verificação Estrita de Tipo
        if type(mod) ~= "string" then
            print_critical_error("Invalid dependency type: expected string, got " .. type(mod))
        end

        -- 2. Validação por Expressão Regular (Regex) estrita
        -- Permite apenas letras, números, hífens, sublinhados e pontos (Padrão LuaRocks)
        if not mod:match("^[%w%-_%.]+$") then
            print_critical_error(string.format("rock '%s': Invalid characters or potential command injection detected.", mod))
        end

        -- 3. Execução segura do require nativo com captura de erros
        local success, result = pcall(require, mod)
        
        if not success then
            -- Aplica o mascaramento de caminhos para proteger o servidor contra Path Disclosure
            local safe_error = sanitize_error_message(result)
            print_critical_error(string.format("Failed to load rock '%s': %s", mod, safe_error))
        end

        loaded_modules[mod] = result
    end

    -- Se múltiplos argumentos foram passados, retorna a tabela com todos; se foi um só, retorna direto
    if #args == 1 then
        return loaded_modules[args[1]]
    end
    
    return loaded_modules
end

return hardened_requires