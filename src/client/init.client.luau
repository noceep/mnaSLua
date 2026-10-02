local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Notify = require(
    ReplicatedStorage.mna.Notify.mnaNotify
)

task.wait(4)

Notify:Send("Settings saved!", "Success", 4)
Notify:Send("Careful!", "Warning", 5)
Notify:Send("Something failed.", "Error", 10)
Notify:Send("Server updated", "Info", 5)
