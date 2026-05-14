Config = {}

Config.SellNPC = {
    model = `a_m_m_beach_01`, -- Balıkçı görünümü
    coords = vector4(-1038.72, -1396.95, 5.55, 73.01), -- Belirttiğiniz konum (Z bir tık aşağı çekildi ayakları yere bassın diye)
}

Config.FishingZone = {
    coords = vector3(1299.27, 4216.42, 33.91),
    radius = 50.0, -- Bu koordinatın 50 metre çevresinde balık tutulabilir
}

Config.Fish = {
    ['fish_cod'] = { price = 50, label = 'Mezgit' },
    ['fish_mackerel'] = { price = 75, label = 'Uskumru' },
    ['fish_bass'] = { price = 150, label = 'Levrek' },
    ['fish_tuna'] = { price = 450, label = 'Ton Balığı' },
    ['fish_salmon'] = { price = 250, label = 'Somon' },
}

Config.BaitChance = 80 -- Yem gitme şansı (%)
Config.SuccessChance = 60 -- Balık gelme şansı (%)

Config.Minigame = {
    type = 'skillbar', -- qb-skillbar kullanacak
    difficulty = {
        duration = math.random(2000, 3000),
        pos = math.random(10, 80),
        width = math.random(10, 20),
    }
}
