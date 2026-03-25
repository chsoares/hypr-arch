<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
    <match target="font">
        <edit name="rgba" mode="assign">
        <const>none</const>
    </edit>
  </match>
  <!-- Prefer Nerd Font over Material Symbols for PUA codepoints (e.g. hyprlock user icon) -->
  <alias>
    <family>Rubik Light</family>
    <prefer>
      <family>Rubik Light</family>
      <family>JetBrainsMono Nerd Font</family>
    </prefer>
  </alias>
  <alias>
    <family>Rubik</family>
    <prefer>
      <family>Rubik</family>
      <family>JetBrainsMono Nerd Font</family>
    </prefer>
  </alias>
</fontconfig>
