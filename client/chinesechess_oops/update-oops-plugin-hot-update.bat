md extensions
cd extensions

IF EXIST oops-plugin-hot-update (
goto update
) ELSE (
goto clone
)

:clone
git clone -b master https://gitee.com/huaa/oops-plugin-framework.git

:update
cd oops-plugin-hot-update
git pull