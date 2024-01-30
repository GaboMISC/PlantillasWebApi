-- Obtiene la version del motor de SQL Server
SELECT	SERVERPROPERTY('ProductVersion') AS ProductVersion, 
		SERVERPROPERTY ('ProductLevel') AS ServicePack, 
		SERVERPROPERTY('Edition') AS Edition, 
		SERVERPROPERTY('EngineEdition') AS EngineEdition, 
		@@VERSION AS Versión;