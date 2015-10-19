/*
Copyright (C) 2015, Cristian García <cristian99garcia@gmail.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

public class Window: Gtk.Window {

    public Vame.GameArea area;
    public Game.Menu menu;
    public Game.MakeGameScreen game_maker;
    public Game.PlayerSelecter player_selecter;
    public Game.Roulette roulette;
    public Game.TurnButton turn_button;

    public Gtk.Box box;

    public Utils.Mode mode;
    public Utils.Song song;
    public bool game_maked = false;

    public Window() {
        this.set_title("Juego de preguntas y respuestas");
        this.maximize();

        this.box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        this.add(this.box);

        this.area = new Vame.GameArea();
        this.area.set_background_color(0.262745098, 0.282352941, 0.317647059);
        this.area.size_changed.connect(this.size_changed_cb);
        this.box.pack_start(this.area, true, true, 0);

        this.menu = new Game.Menu();
        this.menu.play.connect(this.new_game);
        this.menu.exit.connect(() => { this.destroy(); });

        this.player_selecter = new Game.PlayerSelecter();
        this.player_selecter.player_selected.connect((player) => { this.show_roulette(player); });

        this.game_maker = new Game.MakeGameScreen();
        this.game_maker.go_menu.connect(() => { this.set_mode(Utils.Mode.INIT_MENU); });
        this.game_maker.start_game.connect(() => { this.set_mode(Utils.Mode.PLAYING); });

        this.roulette = new Game.Roulette();

        this.turn_button = new Game.TurnButton();
        this.turn_button.clicked.connect(() => {
            this.turn_button.sensitive = false;
            this.area.set_cursor(Gdk.CursorType.ARROW);
            this.roulette.turn();
        });

        this.set_mode(Utils.Mode.INIT_MENU);

        this.realize.connect(this.realize_cb);
        this.destroy.connect(this.destroy_cb);

        this.show_all();
    }

    public void new_game(Game.Menu? menu = null) {
        if (this.game_maked) {
            this.set_mode(Utils.Mode.ASK_LOST_DATA);
        } else {
            this.set_mode(Utils.Mode.MAKING_GAME);
        }
    }

    public void set_mode(Utils.Mode mode) {
        this.menu.hide(this.area);
        this.game_maker.hide(this.area);
        this.player_selecter.hide(this.area);
        this.roulette.hide(this.area);
        this.turn_button.hide(this.area);

        if (this.get_realized()) {  // When click in a menu item, the "HAND" not change
            this.area.set_cursor(Gdk.CursorType.ARROW);
        }

        switch (mode) {
            case Utils.Mode.INIT_MENU:
                this.menu.show(this.area);
                break;

            case Utils.Mode.MAKING_GAME:
                this.game_maker.show(this.area);
                break;

            case Utils.Mode.PLAYING:
                this.player_selecter.set_players(this.game_maker.players);
                this.player_selecter.show(this.area);
                break;

            case Utils.Mode.ROULETTE:
                this.roulette.show(this.area);
                this.turn_button.show(this.area);
                this.roulette.rotation = 0;
                this.play_song(Utils.Song.NULL);
                break;

            case Utils.Mode.RESPONSES:
                break;
        }
    }

    public void size_changed_cb(Vame.GameArea area, int width, int height) {
        this.menu.set_pos(width / 2, 100);
        this.game_maker.set_pos(width, height);
        this.player_selecter.set_pos(width, height);
        this.roulette.set_pos(width / 2 - this.roulette.anchor_x, height / 2 - this.roulette.anchor_y);
        this.turn_button.set_pos(width / 2 - this.turn_button.anchor_x, height / 2 - this.turn_button.anchor_y);
    }

    public void show_roulette(int player) {
        this.set_mode(Utils.Mode.ROULETTE);
    }

    public void play_song(Utils.Song song) {
        this.song = song;

        Vame.SoundManager manager = this.area.get_sound_manager();
        Vame.Sound? sound = null;

        switch (this.song) {
            case Utils.Song.MENU:
                sound = Utils.make_sound("menu.mp3");
                break;

            case Utils.Song.QUESTION:
                int num = (int)GLib.Random.int_range(1, 2);
                sound = Utils.make_sound("chronometer0" + num.to_string() + ".mp3");
                break;

            case Utils.Song.NULL:
                break;
        }

        if (sound != null) {
            manager.set_music(sound);
        } else {
            manager.stop_music();
        }
    }

    private void realize_cb(Gtk.Widget self) {
        this.play_song(Utils.Song.MENU);
    }

    private void destroy_cb(Gtk.Widget self) {
        Gtk.main_quit();
    }
}

void main(string[] args) {
    Gtk.init(ref args);
    Gst.init(ref args);

    Utils.Path path = Utils.Path.get_instance();
    path.set_local_folder(GLib.File.new_for_commandline_arg(args[0]).get_parent().get_path());
    Utils.make_image("play.png");

    new Window();
    Gtk.main();
}
