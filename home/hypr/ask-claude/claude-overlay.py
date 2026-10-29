#!/usr/bin/env python3
import gi, sys, threading, time

gi.require_version("Gtk", "4.0")
gi.require_version("GtkLayerShell", "1.0")
from gi.repository import Gtk, GtkLayerShell, GLib, Pango

LETTER = sys.argv[1] if len(sys.argv) > 1 else "?"
FADE_STEPS = 40
SHOW_TIME = 6  # секунд показувати


class Overlay(Gtk.Window):
    def __init__(self):
        super().__init__()

        # Layer shell — поверх ВСЬОГО, без рамок
        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.OVERLAY)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.TOP, True)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.RIGHT, True)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.TOP, 30)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.RIGHT, 40)
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.NONE)

        self.set_decorated(False)
        self.alpha = 0.0

        label = Gtk.Label(label=LETTER.upper())
        label.set_markup(
            f'<span font="Sans Bold 38" foreground="#e0e0e0">{LETTER.upper()}</span>'
        )

        self.set_child(label)

        # CSS — прозорий фон
        css = Gtk.CssProvider()
        css.load_from_data(b"""
            window {
                background: transparent;
            }
        """)
        self.get_style_context().add_provider(
            css, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        self.present()

        # Запуск fade in після показу
        GLib.timeout_add(50, self.start_fade_in)

    def start_fade_in(self):
        self._fade(0.0, 0.22, FADE_STEPS, 18, self.on_fully_visible)
        return False

    def on_fully_visible(self):
        # Почекати SHOW_TIME секунд потім fade out
        GLib.timeout_add(SHOW_TIME * 1000, self.start_fade_out)

    def start_fade_out(self):
        self._fade(0.22, 0.0, FADE_STEPS, 18, self.quit)
        return False

    def quit(self):
        self.get_application().quit()

    def _fade(self, from_a, to_a, steps, interval_ms, callback):
        step_size = (to_a - from_a) / steps
        current = [from_a]
        count = [0]

        def tick():
            count[0] += 1
            current[0] += step_size
            self.set_opacity(max(0.0, min(1.0, current[0])))
            if count[0] >= steps:
                callback()
                return False
            return True

        GLib.timeout_add(interval_ms, tick)


app = Gtk.Application(application_id="dev.claude.overlay")
app.connect("activate", lambda a: a.add_window(Overlay()))
app.run([])
