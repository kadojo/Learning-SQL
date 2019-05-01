
DECLARE @CustID NVARCHAR(20)
DECLARE @NewNoteKey varchar(12)
 
DECLARE CustImp CURSOR FOR
SELECT CustID FROM [MBCStaff];
 
OPEN CustImp;
FETCH NEXT FROM CustImp INTO @CustID;
WHILE @@FETCH_STATUS = 0
   BEGIN
 
exec AP_HDA_Generate_NoteKey @NewNoteKey output
 
while exists(select * from [CUSEMAIL_HDW] where NOTEKEY_HDW = @NewNoteKey)
exec AP_HDA_Generate_NoteKey @NewNoteKey OUTPUT
 
UPDATE [MBCStaff]
SET [EmailKey] = @NewNoteKey
WHERE CustID = @CustID  
 
      FETCH NEXT FROM CustImp INTO @CustID;
   END;
 
CLOSE CustImp;
DEALLOCATE CustImp;
GO
