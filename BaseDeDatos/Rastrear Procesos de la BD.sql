SELECT session_id, host_name, program_name, status, last_request_end_time, nt_user_name
FROM sys.dm_exec_sessions
WHERE
	host_name = 'VPD51'
	AND session_id = 91; -- SPID (se busca en la traza de base de datos)

EXECUTE Sp_who2;

CREATE TABLE #TablaTemporal
(
	SPID INT,
	Status VARCHAR(255),
	Login VARCHAR(255),
	HostName VARCHAR(255),
	BlkBy VARCHAR(255),
	DBName VARCHAR(255),
	Command VARCHAR(255),
	CPUTime INT,
	DiskIO INT,
	LastBatch VARCHAR(255),
	ProgramName VARCHAR(255),
	SPID2 INT,
	REQUESTID INT
)
INSERT INTO #TablaTemporal EXECUTE sp_who2;
GO
SELECT * FROM #TablaTemporal
WHERE HostName = 'VPD51'
	AND DBName ='SitioValidador'
	--AND SPID = 103
ORDER BY DBName ASC;
GO
DROP TABLE #TablaTemporal;