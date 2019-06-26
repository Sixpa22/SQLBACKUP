#####################################
# Backup para: EVAL                 #
# Espacio almacenamiento:           #
# Subscripción : -                  #
# Instancia: EVAL\SQLEXPRESS        #
# Versión: SQLExpress 2017          #
# Mes: 02                           #
# Año: 2019                         #
#####################################

$NombreServidor ="localhost"
$DirectorioDeCopia = "C:\EVAL_BBDD\BCK"
$DiasDeGuardar = 7

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServidor.SMO") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServidor.SmoExtended") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServidor.ConnectionInfo") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServidor.SmoEnum") | Out-Null
 
$Servidor = New-Object ("Microsoft.SqlServidor.Management.Smo.Servidor") $NombreServidor

$dbs = $Servidor.Databases
$TiempoSTD = Get-Date -format yyyy-MM-dd-HHmmss
Write-Output "<==========================================================[ INICIO :  $TiempoSTD ]==========================================================>" | Out-file C:\EVAL_BBDD\BCK\Informe_backup.txt -append
Write-Output " " | Out-file C:\EVAL_BBDD\BCK\Informe_backup.txt -append

Get-ChildItem "$DirectorioDeCopia\*.bak" |? { $_.lastwritetime -le (Get-Date).AddDays(-$DiasDeGuardar)} |% {Remove-Item $_ -force }
"Removemos si existen los backups anteriores a $DiasDeGuardar días"
# $TiempoSTD2= Get-Date -format 0:dd/MM/yy 0:HH:mm:ss
$TiempoSTD = Get-Date -format yyyy-MM-dd-HHmmss
Write-Output "[$TiempoSTD] Removemos los backups anteriores a $DiasDeGuardar días" | Out-file C:\EVAL_BBDD\BCK\Informe_backup.txt -append
# $TiempoSTD2= Get-Date -format 0:dd/MM/yy 0:HH:mm:ss
Write-Output "[$TiempoSTD] Instancia de SQL: $Instancia" | Out-file C:\EVAL_BBDD\BCK\Informe_backup.txt -append


foreach ($BaseDeDatos in $dbs | where { $_.IsSystemObject -eq $False})
{
           $NombreBBDD = $BaseDeDatos.Name      
        
            $TiempoSTD = Get-Date -format yyyy-MM-dd-HHmmss
            
            $RutaSalida = $DirectorioDeCopia + "\" + $NombreBBDD + "_" + $TiempoSTD + ".bak"
                      
            $smoBackup = New-Object ("Microsoft.SqlServidor.Management.Smo.Backup")
            $smoBackup.Action = "Database"
            $smoBackup.Incremental = $false
            $smoBackup.BackupSetDescription = "Total Backup completo " + $NombreBBDD
            $smoBackup.BackupSetName = $NombreBBDD + " Backup"
            $smoBackup.Database = $NombreBBDD
            $smoBackup.MediaDescription = "Disk"
            $smoBackup.Devices.AddDevice($RutaSalida, "File")
            $smoBackup.SqlBackup($Servidor) 
            "BACKUP ==> $NombreBBDD ($NombreServidor) to $RutaSalida"
            $TiempoSTD = Get-Date -format yyyy-MM-dd-HHmmss
            Write-Output "[$TiempoSTD] Nombre de la base de datos: $RutaSalida" | Out-file -filepath  C:\EVAL_BBDD\BCK\Informe_backup.txt -append
 
               
}
          $TiempoSTD = Get-Date -format yyyy-MM-dd-HHmmss
         Write-Output "[$TiempoSTD] Fin de Backup.... " | Out-file -filepath  C:\EVAL_BBDD\BCK\Informe_backup.txt -append
         $TiempoSTD = Get-Date -format yyyy-MM-dd-HHmmss
        Write-Output "<==========================================================[ FIN : $TiempoSTD ]==========================================================>" | Out-file C:\EVAL_BBDD\BCK\Informe_backup.txt -append
        Write-Output " " | Out-file C:\EVAL_BBDD\BCK\Informe_backup.txt -append

