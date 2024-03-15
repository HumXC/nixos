// const sessions = new Map();
const greetd = await Service.import("greetd");
let currentUser = new Var("HumXC");
let currentSession = new Var("Hyprland");
import { Variable as Var } from "resource:///com/github/Aylur/ags/variable.js";
const user = Widget.Box({
    vertical: true,
    hpack: "center",
    vpack: "end",
    hexpand: true,
    vexpand: true,
    css: "margin-bottom: 2.5em",
    children: [
        Widget.Box({
            class_name: "e",
            css: currentUser.bind().transform(
                (p) => `
                    border-radius: 50%;
                    min-width: 10em;
                    min-height: 10em;
                    background-size: cover;  
                    background-repeat: no-repeat; 
                    background-image: url('/home/greeter/face/${p}');`
            ),
        }),
        Widget.Label({
            label: currentUser.bind(),
            css: "margin-top: 0.5em; font-size: 2em; color: #ffffff;",
        }),
    ],
});

const password_entry = Widget.Entry({
    css: `
        padding-right: 1em;
        padding-left: 1em;
        min-height: 2em;
        border-radius: 3em;
        background-color: transparent;
        border: none;`,
    placeholder_text: "Password",
    visibility: false,
    on_accept: async () => {
        const username = currentUser.value;
        const password = password_entry.text || "";
        const cmd = sessions.get(currentUser.value);
        const env = [];
        password_entry.editable = false;
        greetd.login(username, password, cmd, env).catch((e) => {
            response.label = JSON.stringify(e);
            password_entry.editable = true;
        });
    },
});
const password = Widget.Box({
    hpack: "center",
    hexpand: true,
    child: password_entry,
    css: `
        background-color: rgba(32, 32, 32, 0.8);
        margin-bottom: 6em;
        border-radius: 3em;
        background-color: rgba(255, 255, 255, 0.5);`,
});
const can_go_next = new Var(false);
const can_go_previous = new Var(false);
const next = Widget.Button({
    child: Widget.Icon("go-next"),
    on_clicked: () => {},
    visible: can_go_next.bind(),
});
const previous = Widget.Button({
    child: Widget.Icon("go-next"),
    on_clicked: () => {},
    visible: can_go_previous.bind(),
});
const response = Widget.Label();

const win = Widget.Window({
    name: "wind",
    css: "background-color: transparent;",
    keymode: "on-demand",
    visible: false,
    anchor: ["top", "left", "right", "bottom"],
    child: Widget.Box({
        vertical: true,
        // hpack: "center",
        // vpack: "center",
        // hexpand: true,
        // vexpand: true,
        children: [previous, user, next, password],
    }),
});
const background = Widget.Window({
    name: "background",
    layer: "background",
    visible: false,
    anchor: ["top", "left", "right", "bottom"],
    css: currentUser.bind().transform(
        (u) => `
        min-height: 100px;
        min-width: 100px;
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat; 
        background-color: #000;
        background-image: url('/home/greeter/background/${u}');`
    ),
});

App.config({
    windows: [win, background],
});

Utils.execAsync([ags, "-t", "background"])
    .then(() => {
        Utils.execAsync([ags, "-t", "wind"])
            .then(() => password_entry.grab_focus())
            .catch((err) => print(err));
    })
    .catch((err) => print(err));
