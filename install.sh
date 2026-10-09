from __future__ import annotations

import json
from typing import Any

from textual.app import App, ComposeResult
from textual.containers import Horizontal, Vertical
from textual.screen import Screen
from textual.widgets import Header, SelectionList, Label, Button, Markdown, Select


### JSON Exporter ###

def savejson(data: dict[str, Any]) -> None:
    with open("options.json", "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)


#####################

Head = """
# ALRC OS Installer

> thank you for using ALRC OS

ALRC OS is a Virtual Machine that...
* Runs entirely in a web browser
* Is unblocked
* Has Windows app support
* Has audio support
* Can run games with almost no lag
* Can Bypass School Network
* Is very fast
"""

InstallHead = """
# ALRC OS Installer
"""

LINES = [
    "KDE Plasma (Heavy)",
    "XFCE4 (Lightweight)",
    "I3 (Very Lightweight)",
    "GNOME 42 (Very Heavy)",
    "Cinnamon",
    "LXQT",
]


class InstallScreen(Screen):
    CSS_PATH = "installer.tcss"

    def compose(self) -> ComposeResult:
        yield Header()
        yield Markdown(InstallHead)
        yield Horizontal(
            Vertical(
                Label("Default Apps (you should keep them)"),
                SelectionList[int](
                    ("Wine", 0, True),
                    ("Chrome", 1, True),
                    ("Xarchiver", 2, True),
                    ("Discord", 3, True),
                    ("Steam", 4, True),
                    ("Minecraft", 5, True),
                    id="defaultapps",
                ),
            ),
            Vertical(
                Label("Programming"),
                SelectionList[int](
                    ("OpenJDK 8 (jre)", 0),
                    ("OpenJDK 17 (jre)", 1),
                    ("VSCodium", 2),
                    id="programming",
                ),
            ),
            Vertical(
                Label("Apps"),
                SelectionList[int](
                    ("VLC", 0),
                    ("LibreOffice", 1),
                    ("Synaptic", 2),
                    ("AQemu (VMs)", 3),
                    ("TLauncher", 4),
                    id="apps",
                ),
            ),
        )

        yield Vertical(
            Horizontal(
                Label("Desktop Environment:"),
                Select(
                    id="de",
                    value="KDE Plasma (Heavy)",
                    options=[(line, line) for line in LINES],
                ),
            )
        )
        yield Horizontal(
            Button.error("Back", id="back"),
            Button.warning("Install NOW", id="in"),
        )

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "back":
            self.app.pop_screen()
        elif event.button.id == "in":
            data = {
                "defaultapps": sorted(self.query_one("#defaultapps").selected),
                "programming": sorted(self.query_one("#programming").selected),
                "apps": sorted(self.query_one("#apps").selected),
                "enablekvm": True,
                "DE": self.query_one("#de").value,
            }
            savejson(data)
            self.app.exit()


class InstallApp(App):
    CSS_PATH = "installer.tcss"

    def compose(self) -> ComposeResult:
        yield Header()
        yield Markdown(Head)
        yield Vertical(Button.success("Install", id="install"))

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "install":
            self.push_screen(InstallScreen())


if __name__ == "__main__":
    app = InstallApp()
    app.run()
