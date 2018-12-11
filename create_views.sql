/****** mappings onderdeel 1, 1.6 en 1.8 (als we daarvoor geen aparte view creëren)*/

CREATE VIEW vwRechtsbronDocument
WITH SCHEMABINDING
AS
  (
		SELECT	(CASE ISNULL(Numac,0) WHEN 0 THEN 'https://codex.vlaanderen.be/id/document' ELSE 'http://www.ejustice.just.fgov.be/eli' END) AS URLpart1,
				(CASE ISNULL(Numac,0) WHEN 0 THEN ID ELSE Numac END) AS Identifier,
				(CASE ISNULL(Numac,0) WHEN 0 THEN '' ELSE CONCAT ('/',YEAR(CONVERT(date, Datum))) END) AS datumDocumentJaar,
				(CASE ISNULL(Numac,0) WHEN 0 THEN '' ELSE CONCAT ('/',MONTH(CONVERT(date, Datum))) END) AS datumDocumentMaand,
				(CASE ISNULL(Numac,0) WHEN 0 THEN '' ELSE CONCAT ('/',DAY(CONVERT(date, Datum))) END) AS datumDocumentDag,
				(CASE ISNULL(Numac,0) WHEN 0 THEN '' ELSE (CASE  
					WHEN WetgevingDocumentTypeId in (1000005, 1000011, 1000015, 1000016, 1000020) THEN '/wet'
					WHEN WetgevingDocumentTypeId in (1000001, 1000008, 1000013, 1000026) THEN '/decreet'
					WHEN WetgevingDocumentTypeId in (1000017, 1000031) THEN '/grondwet'
					WHEN WetgevingDocumentTypeId in (1000042) THEN '/ordonnantie'
					ELSE '/besluit'
				END)END) AS typeDocumentURI,
				ID as RGDID,
				CONVERT(date, Datum) AS datumDocumentdatum,
				WetgevingDocumentTypeId AS TypeID
		FROM dbo.WetgevingDocument
  );

 CREATE UNIQUE CLUSTERED INDEX CIX_RGDID
	ON [codex.beheer.vlaanderen.be].[dbo].[vwRechtsbronDocument](RGDID); 

/******************************************************
***View vwRechtsbronDocumentDocumentRelatiesActief***
******************************************************/

USE [codex.beheer.vlaanderen.be]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwRechtsbronDocumentDocumentRelatiesA]
WITH SCHEMABINDING
AS
	(
		SELECT	(CASE ISNULL(Document.Numac,0) WHEN 0 THEN 'https://codex.vlaanderen.be/id/document' ELSE 'http://www.ejustice.just.fgov.be/eli' END) AS URLpart1,
				(CASE ISNULL(Document.Numac,0) WHEN 0 THEN Document.ID ELSE Document.Numac END) AS Identifier,
				(CASE ISNULL(Document.Numac,0) WHEN 0 THEN '' ELSE CONCAT ('/',YEAR(CONVERT(date, Document.Datum))) END) AS datumDocumentJaar,
				(CASE ISNULL(Document.Numac,0) WHEN 0 THEN '' ELSE CONCAT ('/',MONTH(CONVERT(date, Document.Datum))) END) AS datumDocumentMaand,
				(CASE ISNULL(Document.Numac,0) WHEN 0 THEN '' ELSE CONCAT ('/',DAY(CONVERT(date, Document.Datum))) END) AS datumDocumentDag,
				(CASE ISNULL(Document.Numac,0) WHEN 0 THEN '' ELSE (CASE  
					WHEN Document.WetgevingDocumentTypeId in (1000005, 1000011, 1000015, 1000016, 1000020) THEN '/wet'
					WHEN Document.WetgevingDocumentTypeId in (1000001, 1000008, 1000013, 1000026) THEN '/decreet'
					WHEN Document.WetgevingDocumentTypeId in (1000017, 1000031) THEN '/grondwet'
					WHEN Document.WetgevingDocumentTypeId in (1000042) THEN '/ordonnantie'
					ELSE '/besluit'
				END)END) AS typeDocumentURI,
				Document2.ID AS DocumentRelatie,
				DocumentDocumentRelatie.WetgevingDocumentDocumentRelatieTypeId AS RelatieTypeId
		FROM dbo.WetgevingDocument as Document, dbo.WetgevingDocument as Document2, dbo.WetgevingDocumentDocumentRelatie as DocumentDocumentRelatie, dbo.WetgevingDocumentDocumentRelatieType as DocumentDocumentRelatieType
		WHERE DocumentDocumentRelatieType.Id = DocumentDocumentRelatie.WetgevingDocumentDocumentRelatieTypeId
		AND Document.ID = DocumentDocumentRelatie.WetgevingDocumentActiefId
		AND Document2.Id = DocumentDocumentRelatie.WetgevingDocumentPassiefId
	);
GO

/*******************************************************
***View vwRechtsbronDocumentDocumentRelatiesPassief***
*******************************************************/

USE [codex.beheer.vlaanderen.be]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwRechtsbronDocumentDocumentRelatiesP]
WITH SCHEMABINDING
AS
	(
		SELECT 	(CASE ISNULL(Document2.Numac,0) WHEN 0 THEN 'https://codex.vlaanderen.be/id/document' ELSE 'http://www.ejustice.just.fgov.be/eli' END) AS URLpart1,
				(CASE ISNULL(Document2.Numac,0) WHEN 0 THEN Document2.ID ELSE Document2.Numac END) AS Identifier,
				(CASE ISNULL(Document2.Numac,0) WHEN 0 THEN '' ELSE CONCAT ('/',YEAR(CONVERT(date, Document2.Datum))) END) AS datumDocumentJaar,
				(CASE ISNULL(Document2.Numac,0) WHEN 0 THEN '' ELSE CONCAT ('/',FORMAT(CONVERT(date, Document2.Datum), 'MM')) END) AS datumDocumentMaand,
				(CASE ISNULL(Document2.Numac,0) WHEN 0 THEN '' ELSE CONCAT ('/',FORMAT(CONVERT(date, Document2.Datum), 'dd')) END) AS datumDocumentDag,
				(CASE ISNULL(Document2.Numac,0) WHEN 0 THEN '' ELSE (CASE  
					WHEN Document2.WetgevingDocumentTypeId in (1000005, 1000011, 1000015, 1000016, 1000020) THEN '/wet'
					WHEN Document2.WetgevingDocumentTypeId in (1000001, 1000008, 1000013, 1000026) THEN '/decreet'
					WHEN Document2.WetgevingDocumentTypeId in (1000017, 1000031) THEN '/grondwet'
					WHEN Document2.WetgevingDocumentTypeId in (1000042) THEN '/ordonnantie'
					ELSE '/besluit'
				END)END) AS typeDocumentURI,
				Document.ID AS DocumentRelatie,
				DocumentDocumentRelatie.WetgevingDocumentDocumentRelatieTypeId AS RelatieTypeId
		FROM dbo.WetgevingDocument as Document, dbo.WetgevingDocument as Document2, dbo.WetgevingDocumentDocumentRelatie as DocumentDocumentRelatie, dbo.WetgevingDocumentDocumentRelatieType as DocumentDocumentRelatieType
		WHERE DocumentDocumentRelatieType.ReverseId = DocumentDocumentRelatie.WetgevingDocumentDocumentRelatieTypeId
		AND Document.Id = DocumentDocumentRelatie.WetgevingDocumentActiefId
		AND Document2.Id = DocumentDocumentRelatie.WetgevingDocumentPassiefId
	);
GO


/*******************************************************
***View vwRechtsbronDocumentArtikelEnBijlageRelaties***
*******************************************************/
    
CREATE VIEW vwRechtsbronDocumentArtikelEnBijlageRelaties
WITH SCHEMABINDING
AS
	(
		SELECT	(CASE ISNULL(Document.Numac,0) WHEN 0 THEN 'https://codex.vlaanderen.be/id/document' ELSE 'http://www.ejustice.just.fgov.be/eli' END) AS URLpart1,
				(CASE ISNULL(Document.Numac,0) WHEN 0 THEN Document.ID ELSE Document.Numac END) AS Identifier,
				(CASE ISNULL(Document.Numac,0) WHEN 0 THEN '' ELSE CONCAT ('/',YEAR(CONVERT(date, Document.Datum))) END) AS datumDocumentJaar,
				(CASE ISNULL(Document.Numac,0) WHEN 0 THEN '' ELSE CONCAT ('/',MONTH(CONVERT(date, Document.Datum))) END) AS datumDocumentMaand,
				(CASE ISNULL(Document.Numac,0) WHEN 0 THEN '' ELSE CONCAT ('/',DAY(CONVERT(date, Document.Datum))) END) AS datumDocumentDag,
				(CASE ISNULL(Document.Numac,0) WHEN 0 THEN '' ELSE (CASE  
					WHEN Document.WetgevingDocumentTypeId in (1000005, 1000011, 1000015, 1000016, 1000020) THEN '/wet'
					WHEN Document.WetgevingDocumentTypeId in (1000001, 1000008, 1000013, 1000026) THEN '/decreet'
					WHEN Document.WetgevingDocumentTypeId in (1000017, 1000031) THEN '/grondwet'
					WHEN Document.WetgevingDocumentTypeId in (1000042) THEN '/ordonnantie'
					ELSE '/besluit'
				END)END) AS typeDocumentURI,
				WetgevingArtikelVersie.ID AS ArtikelRelatie,
				DocumentArtikelRelatie.WetgevingDocumentArtikelVersieRelatieTypeId AS RelatieTypeId,
                Document.WetgevingDocumentTypeId,
                (CASE WetgevingArtikelVersie.ArtikelType WHEN 'ART' THEN 'artikel' WHEN 'ART.' THEN 'artikel' WHEN 'aanhef' THEN 'artikel' ELSE 'bijlage' END ) as ArtikelType
		FROM dbo.WetgevingDocument as Document, dbo.WetgevingDocumentArtikelVersieRelatie AS DocumentArtikelRelatie, dbo.WetgevingDocumentArtikelVersieRelatieType as DocumentArtikelRelatieType, dbo.WetgevingArtikelVersie
		WHERE DocumentArtikelRelatieType.Id = DocumentArtikelRelatie.WetgevingDocumentArtikelVersieRelatieTypeId
		AND WetgevingArtikelVersie.id = DocumentArtikelRelatie.WetgevingArtikelVersieId
		AND Document.ID = DocumentArtikelRelatie.WetgevingDocumentId
		AND (WetgevingArtikelVersie.ArtikelType LIKE '%BIJLAGE%' OR WetgevingArtikelVersie.ArtikelType LIKE '%ART%' OR WetgevingArtikelVersie.ArtikelType LIKE '%Aanhef%')
	);
    
/*******************************************************
***View vwRechtsbronArtikelEnBijlageRelaties***
*******************************************************/
    
CREATE VIEW vwRechtsbronArtikelEnBijlageRelaties
WITH SCHEMABINDING
AS
	(
		SELECT 	ArtikelVersie2.WetgevingArtikelId AS Artikel2ID,
				ArtikelVersie1.WetgevingArtikelId AS Artikel1ID,
                (CASE ArtikelVersie2.ArtikelType WHEN 'ART' THEN 'artikel' WHEN 'ART.' THEN 'artikel' WHEN 'aanhef' THEN 'artikel' ELSE 'bijlage' END) as Artikel2Type,
                (CASE ArtikelVersie1.ArtikelType WHEN 'ART' THEN 'artikel' WHEN 'ART.' THEN 'artikel' WHEN 'aanhef' THEN 'artikel' ELSE 'bijlage' END) as Artikel1Type,
                ArtikelArtikelRelatie.WetgevingArtikelVersieArtikelVersieRelatieTypeId AS RelatieTypeID
		FROM dbo.WetgevingArtikelVersieArtikelVersieRelatie AS ArtikelArtikelRelatie, dbo.WetgevingArtikelVersieArtikelVersieRelatieType as ArtikelArtikelRelatieType, dbo.WetgevingArtikelVersie as ArtikelVersie1, dbo.WetgevingArtikelVersie as ArtikelVersie2
		WHERE ArtikelArtikelRelatieType.Id = ArtikelArtikelRelatie.WetgevingArtikelVersieArtikelVersieRelatieTypeId
		AND ArtikelVersie1.id = ArtikelArtikelRelatie.WetgevingArtikelVersieActiefId
		AND ArtikelVersie2.id = ArtikelArtikelRelatie.WetgevingArtikelVersiePassiefId
        AND (ArtikelVersie1.ArtikelType LIKE '%BIJLAGE%' OR ArtikelVersie1.ArtikelType LIKE '%ART%' OR ArtikelVersie1.ArtikelType LIKE '%Aanhef%')
		AND (ArtikelVersie2.ArtikelType LIKE '%BIJLAGE%' OR ArtikelVersie2.ArtikelType LIKE '%ART%' OR ArtikelVersie2.ArtikelType LIKE '%Aanhef%')
	);
    