Config = {

    outline = {
        color = { 255, 255, 255, 255 }, -- RGB + Alpha value
        size = 1,
        -- 0: normal
        -- 1: small
    },

    interaction = {
        method = "ox_target", -- "ox_target" or "prompt"
        text = {
            ["interact"] = "Premi ~INPUT_CONTEXT~ per interagire",
            ["pickup"] = "Premi ~INPUT_MELEE_ATTACK_LIGHT~ per raccogliere",
        }
    },

    evidences = {

        ["molester"] = {
            pickup = false,
            tags = nil --[[ { "user" } ]],
            prop = "prop_laptop_lester",
            coords = vec3(-1377.4250, -535.4015, 30.2113),
            nui = {
                model = "asus_rog_zephyrus_g14_2024.glb",
                offset = vec3(0, -0.1, 0),
                distance = 2,
                title = "Laptop di Lester the Molester",
                description = "Questo laptop sembrerebbe appartenere ad un certo **Lester**, non sappiamo molto su di lui ma a quanto pare ha aiutato la __banda__ a fuggire dal penitenziario.",
            },
        },
    }
}