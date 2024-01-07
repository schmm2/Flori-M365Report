# Template Issue

There is an issue with the Template system.
To load an existing Template will eventually break the Headings.
https://github.com/EvotecIT/PSWinDocumentation/issues/12

Solution: 
Create an empty Template.docx and merge it with our template this will result in a new Template which will not be effected with the issue.

```powershell
$BlankFilePath 
WordDocument = New-WordDocument -FilePath $BlankFilePath 
Save-WordDocument $WordDocument 
Merge-WordDocument -FilePath1 $BlankFilePath -FilePath2 "D:\Git\M365Report\PSModule\M365Report\Data\Template.docx" -FileOutput D:\Git\M365Report\PSModule\M365Report\Data\TemplateNEW.docx
```

The old Template.docx needs to be replaced wih the new one.

Those steps are necessary when changes to the template.docx have been made.