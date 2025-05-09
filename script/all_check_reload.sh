#!/bin/bash
env_name=$1
#世界相关服
cd world/logserver
bash make/script/check_reload.sh load_mods${env_name}.lua
cd ../../

cd world/centerserver
bash make/script/check_reload.sh load_mods${env_name}.lua
cd ../../

cd world/matchserver
bash make/script/check_reload.sh load_mods${env_name}.lua
cd ../../

cd world/loginserver
bash make/script/check_reload.sh load_mods${env_name}_1.lua
bash make/script/check_reload.sh load_mods${env_name}_2.lua
cd ../../

cd world/hallserver
bash make/script/check_reload.sh load_mods${env_name}_1.lua
bash make/script/check_reload.sh load_mods${env_name}_2.lua
cd ../../

#游戏
cd games/chinese_chess
bash make/script/check_reload.sh load_mods${env_name}_1.lua
bash make/script/check_reload.sh load_mods${env_name}_2.lua
cd ../../

cd games/digitalbomb
bash make/script/check_reload.sh load_mods${env_name}_1.lua
bash make/script/check_reload.sh load_mods${env_name}_2.lua
cd ../../