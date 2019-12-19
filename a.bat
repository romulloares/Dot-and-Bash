@Echo OFF

For /F "Usebackq Delims=" %%# in (
    "rola.txt"
) do (
    Echo+
    Echo [+] Estou aqui: %%#

     echo %%#
	 start cmd.exe @cmd /k "TITLE Host %%# && PSEXEC -n 5 %%# \\172.16.1.199\\Users\LEADCOMM\Desktop\19_12_2019\WC.bat 1>nul && (

        Echo     [OK]) || (
        Echo     [FUDEU])
)

Pause&Exit