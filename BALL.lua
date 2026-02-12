local scripts = {
    "https://api.luarmor.net/files/v4/loaders/dc843cb3239b9d6300ec91a57188c37d.lua",
    "https://raw.githubusercontent.com/diarians/blade/refs/heads/main/Q.lua",
    "https://raw.githubusercontent.com/diarians/blade/refs/heads/main/TpSpawn.lua"
}

for _, url in ipairs(scripts) do
    task.spawn(function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)

        if not ok then
            warn("Erro:", url, err)
        end
    end)
end
