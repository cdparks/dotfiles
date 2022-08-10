/*
Copyright 2021 Christopher D. Parks

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
SETUP

qmk setup -H /Users/cparks/code/qmk_firmware
qmk compile -kb sneakbox/ava -km default
cd qmk_firmware
qmk config user.keyboard=sneakbox/ava
qmk config user.keymap=cdparks
qmk new-keymap
mkdir -p keyboards/sneakbox/ava/keymaps/cdparks
cp ~/dotfiles/keymap.c keyboards/sneakbox/ava/keymaps/cdparks/keymap.c
qmk compile
qmk flash

*/

#include QMK_KEYBOARD_H

// Keymap layers
typedef enum {
  _BASE,
  _SWP,
  _FN
} layer_names_t;

// Custom keycodes
typedef enum {
  // Copy screen selection to clipboard
  CLIPSEL = SAFE_RANGE,
  // Toggle LED indicator mode
  TOGLIND
} custom_keycodes_t;

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  // Base layer
  [_BASE] = LAYOUT_ava_split_bs(
    KC_ESC,  KC_GRV,  KC_1,     KC_2,    KC_3,    KC_4,    KC_5,    KC_6,          KC_7,     KC_8,    KC_9,    KC_0,    KC_MINS, KC_EQL,   KC_BSPC, KC_BSPC,
    KC_PGUP, KC_TAB,            KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,          KC_Y,     KC_U,    KC_I,    KC_O,    KC_P,    KC_LBRC,  KC_RBRC, KC_BSLS,
    KC_PGDN, KC_LCTL,           KC_A,    KC_S,    KC_D,    KC_F,    KC_G,          KC_H,     KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT,           KC_ENT,
    CLIPSEL, KC_LSFT,           KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,          TG(_SWP), KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH,  KC_UP,   KC_DEL,
             KC_LALT, KC_LGUI,                             KC_LSFT, KC_LGUI,       KC_SPC,   MO(_FN),                            KC_LEFT,  KC_DOWN, KC_RGHT),

  // Temporarily swap Control and Command (LGUI) for macOS reasons
  [_SWP] = LAYOUT_ava_split_bs(
    _______, _______, _______, _______, _______, _______, _______, _______,        _______,  _______, _______, _______, _______, _______,  _______, _______,
    _______, _______,          _______, _______, _______, _______, _______,        _______,  _______, _______, _______, _______, _______,  _______, _______,
    _______, KC_LGUI,          _______, _______, _______, _______, _______,        _______,  _______, _______, _______, _______, _______,           _______,
    _______, _______,          _______, _______, _______, _______, _______,        _______,  _______, _______, _______, _______, _______,  _______, _______,
             _______, _______,                            _______, KC_LCTL,        _______,  _______,                            _______,  _______, _______),

  // Function layer
  [_FN] = LAYOUT_ava_split_bs(
    _______, _______, KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_F6,          KC_F7,    KC_F8,   KC_F9,   KC_F10,  KC_F11,  KC_F12,   _______, _______,
    KC_VOLU, _______,          _______, _______, KC_UP,   KC_MPLY, _______,        _______,  _______, _______, _______, _______, RGB_RMOD, RGB_MOD, RGB_TOG,
    KC_VOLD, _______,          _______, KC_LEFT, KC_DOWN, KC_RGHT, _______,        KC_HOME,  KC_PGDN, KC_PGUP, KC_END,  RGB_VAD, RGB_VAI,           _______,
    QK_BOOT, _______,          _______, _______, _______, _______, _______,        _______,  _______, _______, _______, RGB_SAD, RGB_SAI,  _______, RGB_HUI,
             _______, _______,                            _______, _______,        TOGLIND,  _______,                            _______,  _______, _______),
};

// Indicator modes
typedef enum {
  // Use LEDs to indicate which layer we're in
  SHOW_LAYER = 0,
  // Set all LEDs on
  ALL_ON,
  // Set all LEDs off
  ALL_OFF,
} indicator_mode_t;

// Current layer mode
static indicator_mode_t indicator_state = SHOW_LAYER;

bool process_record_user(uint16_t keycode, keyrecord_t* record) {
  switch (keycode) {
    // Copy screen selection to clipboard
    case CLIPSEL:
      if (record->event.pressed) {
        // Cmd+Ctrl+Shift+4
        SEND_STRING(SS_LGUI(SS_LCTL(SS_LSFT(SS_TAP(X_4)))));
      }
      return false;
    // Toggle LED indicator mode
    case TOGLIND:
      if (record->event.pressed) {
        indicator_state = (indicator_state + 1) % 3;
      }
      return false;
  }
  return true;
}

// LED pin aliases
#define LED_TOP D7
#define LED_LFT D4
#define LED_RGT D6

// Which layer is enabled
static uint8_t current_layer = 0;

// Change illuminated LED when layer state changes
layer_state_t layer_state_set_user(layer_state_t state) {
  current_layer = get_highest_layer(state);
  return state;
}

// Set LED pin outputs
void keyboard_pre_init_user(void) {
  setPinOutput(LED_TOP);
  setPinOutput(LED_LFT);
  setPinOutput(LED_RGT);
}

// Update LEDs based on indicator_state
bool led_update_user(led_t usb_led) {
  switch (indicator_state) {
    case SHOW_LAYER:
      writePin(LED_TOP, current_layer == _BASE);
      writePin(LED_LFT, current_layer == _SWP);
      writePin(LED_RGT, current_layer == _FN);
      break;
    case ALL_ON:
      writePin(LED_TOP, 1);
      writePin(LED_LFT, 1);
      writePin(LED_RGT, 1);
      break;
    case ALL_OFF:
      writePin(LED_TOP, 0);
      writePin(LED_LFT, 0);
      writePin(LED_RGT, 0);
      break;
  }
  return false;
}
