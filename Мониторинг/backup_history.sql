DECLARE @BackupType VARCHAR(30) = 'D'
       ,@dbName NVARCHAR(128) = 'master';

SELECT
    CASE s.[type]
        WHEN 'D' THEN 'Full'
        WHEN 'I' THEN 'Differential'
        WHEN 'L' THEN 'Transaction Log'
        WHEN 'F' THEN 'File or Filegroup'
        WHEN 'G' THEN 'Differential file'
        WHEN 'P' THEN 'Partial'
        WHEN 'Q' THEN 'Differential partial'
        ELSE 'Unknown'
    END AS BackupType,
    s.database_name as DatabaseName,
    m.physical_device_name,
    CAST(s.backup_size / 1024./1024. AS INT) AS [Size MB],
    CAST(s.compressed_backup_size / 1024./1024. AS INT) AS [Compr MB],
    CAST(s.compressed_backup_size / NULLIF(s.backup_size, 0) AS DECIMAL(6,2)) AS [Ratio%],
    s.user_name,
    CONVERT(VARCHAR(30), DATEADD(SECOND, DATEDIFF(SECOND, s.backup_start_date, s.backup_finish_date), CAST('1900-01-01' as datetime)), 108) AS TimeTaken,
    s.backup_start_date,
    s.backup_finish_date,
    s.recovery_model,  
    s.is_copy_only,
    s.has_bulk_logged_data,
    s.is_snapshot,
    s.is_readonly,
    s.is_single_user,
    s.is_damaged,
    s.has_incomplete_metadata,
    s.name,  
    s.position,  
    s.server_name,
    s.database_version,
    s.has_backup_checksums,
    s.is_password_protected,
    CAST(s.first_lsn AS VARCHAR(50)) AS first_lsn,
    CAST(s.last_lsn AS VARCHAR(50)) AS last_lsn
FROM msdb.dbo.backupset s
JOIN msdb.dbo.backupmediafamily m
    on s.media_set_id = m.media_set_id
WHERE (s.[type] = @BackupType OR @BackupType IS NULL)
ORDER BY
    backup_start_date DESC,
    backup_finish_date DESC;
go