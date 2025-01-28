---Gets all the itcems
---@return { name: string, pickup: number, tags: table, prop: string, coords: vector4, model: string, offset: vector3, distance: number, title: string, description: string }
function GetItems()
    return MySQL.query.await("SELECT * FROM `br_evidence`")
end

---Adds item in db
---@param data { name: string, pickup: number, tags: table, prop: string, coords: vector4, model: string, offset: vector3, distance: number, title: string, description: string }
function CreateItem(data)
    local query = "INSERT INTO `br_evidence` (name, pickup, tags, prop, coords, model, offset, distance, title, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    local id = MySQL.insert.await(query, {
        data.name, data.pickup, data.tags, data.prop, data.coords, data.model, data.offset, data.distance, data.title, data.description
    })
end

---Removes item from db
function RemoveItem(name)
    MySQL.rawExecute.await("DELETE FROM table_name WHERE condition")
end