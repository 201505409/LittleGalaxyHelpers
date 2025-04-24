--Copy and Paste the Results of this script into a text file
--and load that file into object viewer

DECLARE @rootAppEngId int

CREATE TABLE #Attribs(attrib varchar(150))

INSERT INTO #Attribs (attrib) VALUES 
------------------------------------------------
--Configure Required Attributes below
------------------------------------------------
('.Engine.Historian.ConnectState'),
('.Scheduler.TimeIdleAvg'),
('.Engine.ProcessCPULoad'),
('.Scheduler.ScanOverrunsConsecCnt')
------------------------------------------------
SELECT @rootAppEngId = [template_definition_id]
  FROM [dbo].[template_definition]
  WHERE original_template_tagname = '$AppEngine'

SELECT(
SELECT 'Engine Audit' as "Tab", (
  SELECT t1.[hierarchical_name] + t2.attrib COLLATE SQL_Latin1_General_CP1_CI_AS as ReferenceString
  FROM [dbo].[gobject] as t1
  JOIN #Attribs as t2
  ON 1 = 1
  WHERE t1.template_definition_id = @rootAppEngId 
  AND t1.[is_template] = 0
  AND t1.deployed_package_id <> 0
  ORDER BY ReferenceString
  FOR XML PATH(''), type
 ) FOR XML RAW('Watch'), type
 ) FOR XML RAW('VisualLMXTestTool')

DROP TABLE #Attribs
