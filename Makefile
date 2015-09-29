VALAC = valac
OPTIONS = --target-glib 2.32

VALAPKG = --pkg gtk+-3.0 \
          --pkg gdk-3.0 \
          --pkg gstreamer-0.10

VAME_SRC = src/vame/area.vala \
           src/vame/image.vala \
           src/vame/sprite.vala \
           src/vame/text.vala \
           src/vame/sound.vala \
           src/vame/utils.vala

SRC = src/game.vala \
      src/buttons.vala \
      src/menu.vala \
      src/game_make_screen.vala \
      src/player_selecter.vala \
      src/roulette.vala \
      src/utils.vala

BIN = game

all:
	$(VALAC) $(OPTIONS) $(VALAPKG) $(VAME_SRC) $(SRC) -o $(BIN)

clean:
	rm -f $(BIN)

