# 📦 requires package

## ℹ️ About
A secure Lua module loader designed to protect applications against injections and internal path leaks while maintaining full compatibility with modern versions.

---

![Lunar IDLE](./assets/requires_banner.jpeg)

![Linux](https://img.shields.io/badge/Linux-supported-blue?logo=linux&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-supported-blue?logo=apple&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-supported-blue?logo=windows&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-5.1--5.4-2C2D72?logo=lua&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 🚀 Main Features

* **Input Sanitization:** Strict validation using regular expressions to accept only safe characters in module names.
* **Type Checking:** Ensures that the provided argument is strictly of the string type.
* **Path Disclosure Protection:** Hides internal operating system paths in error messages to prevent directory exposure.
* **High Performance:** Immediate in-memory execution that leverages the native Lua interpreter cache without introducing noticeable bottlenecks.

---

## 👤 Use Cases and Common Error Examples

The module intercepts invalid or malicious requests before they reach the file system, returning controlled messages.

### 1. Code Injection Attempt or Invalid Characters
* **Scenario:** The user attempts to load a module by passing malicious commands or special characters (such as slashes, extra dots, or spaces).
* **What happens:** Validation immediately blocks the input.
* **Common Error Example:**

```bash
Error: Invalid module name or malicious characters detected.
```

### 2. Incorrect Data Type
Scenario: The developer passes an argument that is not text (for example, a number or a table) to the loading function.

What happens: The typing system detects the anomaly and rejects execution.

Common Error Example:
```bash
Error: Module name must be strictly a string.
```

### 3. Internal Failure with Masked Path
Scenario: The module fails to load due to an internal runtime error, but the system hides the directory structure of the machine where the script is running.

What happens: The interpreter's original message is cleaned.

Complete Error Example:
```bash
[Secure Execution Error] Failed to load requested module. Internal details hidden for security reasons.
```

### 🔥 tests(test.lua)

> valid rock name and wrong or invalid rock name

```lua
-- test requires(v2)
local requires = require("requires")
local pkg = requires("dkjson", "otherrock") -- correct:("dkjson") fake or name incorrect rock("otherrock")

local encoded = pkg.dkjson.encode({ hello = "world" })
print("JSON coded:", encoded)
```

> valid rock name and wrong type(not string) or invalid rock name, terminal commands.

```lua
-- test requires(v4[complete])
local requires = require("requires")
local pkg = requires("dkjson", "echo $PATH", "function name() do print('name') end", 1)

local encoded = pkg.dkjson.encode({ hello = "world" })
print("JSON coded:", encoded)
```

```
Desclaimer: Upon the first type, name, or command/function injection error, it returns an error and terminates the application for security reasons; therefore, use only valid names for Lua packages, adhering to the standard naming convention.
```

## 🧭 Usage
> correct usage requires rock
```lua
local requires = require("requires")
local pkg = requires("dkjson", "date", "ansicolor")

-- definition-area
local c = pkg.ansicolor

-- application-area
local future = pkg.date():adddays(10)

local result_encoded = pkg.dkjson.encode({
    age = "10",
    name = "requires",
    status = "ok",
    -- Using the date library's formatting method to get the future date.
    days = future:fmt("%Y-%m-%d")
})

-- Apply c
print(c("%{red}Result: %{reset}") .. result_encoded)
```

> cli aplication example

```lua
local requires = require("requires")

-- Loading multiple CLI packages securely
local pkg = requires("argparse", "dkjson", "ansicolors")

-- definition-area
local c = pkg.ansicolors
local parser = pkg.argparse("cli-tool", "Secure CLI example with requires.lua")

parser:argument("name", "Your name."):default("World")
parser:option("-s --status", "Application status"):default("ok")
parser:flag("-v --verbose", "Displays additional details.")

local args = parser:parse()

-- application-area
local data = {
    app = "CLI Application",
    user = args.name,
    status = args.status,
    timestamp = os.date("%Y-%m-%d %H:%M:%S")
}

local json_output = pkg.dkjson.encode(data, { indent = true })

-- Colored terminal output
print(c("%{green}=== Executed Successfully! ===%{reset}"))
print(json_output)

if args.verbose then
    print(c("%{yellow}Verbose mode enabled. Operation completed for: " .. args.name .. "%{reset}"))
end
```

> desktop iup(UI) example

```lua
local requires = require("requires")

-- Loading multiple desktop/UI packages securely
local pkg = requires("iup", "ansicolors")

-- definition-area
local c = pkg.ansicolors
local iup = pkg.iup

-- Initialize IUP
iup.Open()

-- Create UI elements
local txt_area = iup.text {
    multiline = "YES",
    expand = "YES",
    value = "Type your notes here...",
    bgcolor = "30 30 30",  -- Dark theme background
    fgcolor = "220 220 220" -- Light text color
}

local btn_clear = iup.button {
    title = "Clear",
    bgcolor = "128 0 128",  -- Purple theme
    fgcolor = "255 255 255"
}

local btn_save = iup.button {
    title = "Save",
    bgcolor = "128 0 128",  -- Purple theme
    fgcolor = "255 255 255"
}

-- Button callbacks
function btn_clear:action()
    txt_area.value = ""
    print(c("%{yellow}Text area cleared.%{reset}"))
end

function btn_save:action()
    print(c("%{green}Content saved: %{reset}") .. tostring(txt_area.value))
end

-- Layout alignment: buttons aligned to the right horizontally
local hbox_buttons = iup.hbox {
    iup.fill{},
    btn_clear,
    btn_save,
    alignment = "ACENTER",
    gap = "5"
}

local vbox_main = iup.vbox {
    txt_area,
    hbox_buttons,
    margin = "10x10",
    gap = "10"
}

local dlg = iup.dialog {
    vbox_main,
    title = "Secure Desktop App with requires.lua",
    size = "400x300"
}

-- application-area
print(c("%{cyan}Starting desktop application...%{reset}"))
dlg:show()
iup.MainLoop()
iup.Close()
```

> web application with pegasus and other rocks.

```lua
local requires = require("requires")

-- loading rocks securily
local pkg = requires(
    "pegasus",
    "router",
    "luasql.mysql",
    "lustache",
    "luacrypto",
    "luasec",
    "dkjson"
)

-- definition-area
local Pegasus = pkg.pegasus
local Router = pkg.router
local luasql = pkg.luasql
local lustache = pkg.lustache
local crypto = pkg.luacrypto
local dkjson = pkg.dkjson

local router = Router.new()

-- Route to the home page (HTML).
router:get("/", function(req, rep)
    local template = [[<html><head><title>{{title}}</title></head><body><h1>{{heading}}</h1><a href='/api'>API JSON</a></body></html>]]
    local view_data = {
        title = "Secure Web App",
        heading = "Welcome to Pegasus"
    }
    local html_output = lustache:render(template, view_data)
    
    rep:addHeader("Content-Type", "text/html")
    rep:write(html_output)
end)

-- API route (JSON with encryption and data).
router:get("/api", function(req, rep)
    local secure_hash = crypto.digest("sha256", "token-" .. os.time())
    local payload = {
        status = "success",
        token = secure_hash
    }
    local json_output = dkjson.encode(payload)

    rep:addHeader("Content-Type", "application/json")
    rep:write(json_output)
end)

local server = Pegasus:new({ port = 8080 })

-- application-run
print("Server running on http://localhost:8080")
server:start(function(req, rep)
    if not router:execute(req:path(), req:method(), req, rep) then
        rep:status(404)
        rep:write("Not Found")
    end
end)
```

## 🧬 Changelog and Development Evolution
v0.0.1-1 (Current Version):

Implementation of shielding against malicious commands via Regex (^[%w%-_%.]+$).
Addition of strict type checking to prevent dynamic typing failures.
Development of automatic file path masking in error logs.
Multi-version compatibility validation guaranteed for the current ecosystem.

___
## 📒 License

MIT © codebabel

---

<sub>Part of the **minguanteEcossys** ecosystem — bringing Lua back to life.</sub>
