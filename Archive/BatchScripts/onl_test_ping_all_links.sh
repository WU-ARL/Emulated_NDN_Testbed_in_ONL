#!/bin/bash

source ~/.topology

# CAIDA test links to UCLA, UCI, UA, TONGJI
echo "CAIDA -- UCLA"
ssh $h5x1 "ping -c 1 -q h11x1"
echo "CAIDA -- UCI"
ssh $h5x1 "ping -c 1 -q h7x1"
echo "CAIDA -- UA"
ssh $h5x1 "ping -c 1 -q h3x1"
echo "CAIDA -- TONGJI"
ssh $h5x1 "ping -c 1 -q h32x1"

# UCI test links to UCLA, REMAP
echo "UCI -- UCLA"
ssh $h7x1 "ping -c 1 -q h11x1"
echo "UCI -- REMAP"
ssh $h7x1 "ping -c 1 -q h9x1"

# UCLA test links to REMAP, CSU, PKU
echo "UCLA -- REMAP"
ssh $h11x1 "ping -c 1 -q h9x1"
echo "UCLA -- CSU"
ssh $h11x1 "ping -c 1 -q h15x2"
echo "UCLA -- PKU"
ssh $h11x1 "ping -c 1 -q h43x2"

# REMAP test links to BYU, CSU, UA
echo "REMAP -- BYU"
ssh $h9x1 "ping -c 1 -q h13x1"
echo "REMAP -- CSU"
ssh $h9x1 "ping -c 1 -q h15x2"
echo "REMAP -- UA"
ssh $h9x1 "ping -c 1 -q h3x1"

# UA test links to BYU, CSU, WU, UM, WASEDA
echo "UA -- BYU"
ssh $h3x1 "ping -c 1 -q h13x1"
echo "UA -- CSU"
ssh $h3x1 "ping -c 1 -q h15x2"
echo "UA -- WU"
ssh $h3x1 "ping -c 1 -q h28x1"
echo "UA -- UM"
ssh $h3x1 "ping -c 1 -q h21x1"
echo "UA -- WASEDA"
ssh $h3x1 "ping -c 1 -q h34x1"

# BYU test links to CSU
echo "BYU -- CSU"
ssh $h13x1 "ping -c 1 -q h15x2;"

# CSU test links to MICH, UIUC, KISTI
echo "CSU -- MICH"
ssh $h15x2 "ping -c 1 -q h27x1"
echo "CSU -- UIUC"
ssh $h15x2 "ping -c 1 -q h30x1"
echo "CSU -- KISTI"
ssh $h15x2 "ping -c 1 -q h36x1"

# WU test links to UM, VERISIGN, UIUC
echo "WU -- UM"
ssh $h28x1 "ping -c 1 -q h21x1"
echo "WU -- UIUC"
ssh $h28x1 "ping -c 1 -q h30x1"
echo "WU -- VERISIGN"
ssh $h28x1 "ping -c 1 -q h23x2"

# UIUC test links to MICH PADUA
echo "UIUC -- MICH"
ssh $h30x1 "ping -c 1 -q h27x1"
echo "UIUC -- PADUA"
ssh $h30x1 "ping -c 1 -q h47x1"

# UM test links to MICH, NEU, ORANGE, VERISIGN
echo "UM -- MICH"
ssh $h21x1 "ping -c 1 -q h27x1"
echo "UM -- VERISIGN"
ssh $h21x1 "ping -c 1 -q h23x2"
echo "UM -- NEU"
ssh $h21x1 "ping -c 1 -q h25x2"
echo "UM -- ORANGE"
ssh $h21x1 "ping -c 1 -q h53x2"

# MICH test links to VERISIGN, NEU, LIP6
echo "MICH -- VERISIGN"
ssh $h27x1 "ping -c 1 -q h23x2"
echo "MICH -- NEU"
ssh $h27x1 "ping -c 1 -q h25x2"
echo "MICH -- LIP6"
ssh $h27x1 "ping -c 1 -q h49x1"

# NEU test links to NTNU, PKU
echo "NEU -- NTNU"
ssh $h25x2 "ping -c 1 -q h51x2"
echo "NEU -- PKU"
ssh $h25x2 "ping -c 1 -q h43x2"

# LIP6 test links to URJC, NTNU, SYSTEMX, ORANGE, BASEL
echo "LIP6 -- URJC"
ssh $h49x1 "ping -c 1 -q h44x1"
echo "LIP6 -- ORANGE"
ssh $h49x1 "ping -c 1 -q h53x2"
echo "LIP6 -- SYSTEMX"
ssh $h49x1 "ping -c 1 -q h57x1"
echo "LIP6 -- BASEL"
ssh $h49x1 "ping -c 1 -q h55x2"
echo "LIP6 -- NTNU"
ssh $h49x1 "ping -c 1 -q h51x2"

# URJC test links to ORANGE, BASEL, PADUA
echo "URJC -- ORANGE"
ssh $h44x1 "ping -c 1 -q h53x2"
echo "URJC -- PADUA"
ssh $h44x1 "ping -c 1 -q h47x1"
echo "URJC -- BASEL"
ssh $h44x1 "ping -c 1 -q h55x2"

# NTNU test links to SYSTEMX, BASEL, PKU
echo "URJC -- SYSTEMX"
ssh $h51x2 "ping -c 1 -q h57x1"
echo "URJC -- PKU"
ssh $h51x2 "ping -c 1 -q h43x2"
echo "URJC -- BASEL"
ssh $h51x2 "ping -c 1 -q h55x2"

# SYSTEMX test links to ORANGE, BASEL
echo "SYSTEMX -- ORANGE"
ssh $h57x1 "ping -c 1 -q h53x2"
echo "SYSTEMX -- BASEL"
ssh $h57x1 "ping -c 1 -q h55x2"

# ORANGE test links to PADUA, BASEL, WASEDA
echo "ORANGE -- PADUA"
ssh $h53x2 "ping -c 1 -q h47x1"
echo "ORANGE -- WASEDA"
ssh $h53x2 "ping -c 1 -q h34x1"
echo "ORANGE -- BASEL"
ssh $h53x2 "ping -c 1 -q h55x2"

# BASEL test links to PADUA, PKU
echo "BASEL -- PADUA"
ssh $h55x2 "ping -c 1 -q h47x1"
echo "BASEL -- PKU"
ssh $h55x2 "ping -c 1 -q h43x2;"

# PKU test links to BUPT, ANYANG, TONGJI
echo "PKU -- BUPT"
ssh $h43x2 "ping -c 1 -q h42x2"
echo "PKU -- ANYANG"
ssh $h43x2 "ping -c 1 -q h38x1"
echo "PKU -- TONGJI"
ssh $h43x2 "ping -c 1 -q h32x1"

# BUPT test links to ANYANG, TONGJI, KISTI
echo "BUPT -- ANYANG"
ssh $h42x2 "ping -c 1 -q h38x1"
echo "BUPT -- KISTI"
ssh $h42x2 "ping -c 1 -q h36x1"
echo "BUPT -- TONGJI"
ssh $h42x2 "ping -c 1 -q h32x1"

# TONGJI test links to ANYANG, WASEDA
echo "TONGJI -- ANYANG"
ssh $h32x1 "ping -c 1 -q h38x1"
echo "TONGJI -- WASEDA"
ssh $h32x1 "ping -c 1 -q h34x1;"

# ANYANG test links to KISTI, WASEDA
echo "ANYANG -- KISTI"
ssh $h38x1 "ping -c 1 -q h36x1"
echo "ANYANG -- WASEDA"
ssh $h38x1 "ping -c 1 -q h34x1"

# KISTI test links to WASEDA
echo "KISTI -- WASEDA"
ssh $h36x1 "ping -c 1 -q h34x1;"
