report 60184 POEmailNotification
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        SendApprovedPOEmails();
    end;
    var myInt: Integer;
    local procedure SendApprovedPOEmails()
    var
        ApprovalEntry: Record "Approval Entry";
        PurchaseHeader: Record "Purchase Header";
        Body: Text;
        LastDocType: Enum "Approval Document Type";
        LastDocNo: Code[20];
        LastSeqNo: Integer;
        // ApprovalEntry: Record "Approval Entry";
        // PurchaseHeader: Record "Purchase Header";
        ProcessedPOs: Dictionary of[Text, Boolean];
        POKey: Text;
        ApprovalEntryCheck: Record "Approval Entry";
        AllApproved: Boolean;
        StartDateTime: DateTime;
        EndDateTime: DateTime;
        HasApprovedPO: Boolean;
    begin
        HasApprovedPO:=false;
        Body:='<html><body>' + GetGreeting() + ' team,<br><br>' + 'The following Purchase Orders have been approved:<br><br>' + '<table border="1" cellpadding="5">' + '<tr>' + '<th>PO No.</th>' + '<th>Vendor Name</th>' + '<th>Amount</th>' + '</tr>';
        EndDateTime:=CurrentDateTime();
        StartDateTime:=EndDateTime - (30 * 60 * 1000);
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Table ID", Database::"Purchase Header");
        ApprovalEntry.SetRange("Last Date-Time Modified", StartDateTime, EndDateTime);
        if ApprovalEntry.FindSet()then repeat POKey:=Format(ApprovalEntry."Document Type") + '|' + ApprovalEntry."Document No.";
                if not ProcessedPOs.ContainsKey(POKey)then begin
                    AllApproved:=true;
                    ApprovalEntryCheck.Reset();
                    ApprovalEntryCheck.SetRange("Table ID", Database::"Purchase Header");
                    ApprovalEntryCheck.SetRange("Document Type", ApprovalEntry."Document Type");
                    ApprovalEntryCheck.SetRange("Document No.", ApprovalEntry."Document No.");
                    if ApprovalEntryCheck.FindSet()then repeat if ApprovalEntryCheck.Status <> ApprovalEntryCheck.Status::Approved then begin
                                AllApproved:=false;
                            end;
                        until(ApprovalEntryCheck.Next() = 0) or not AllApproved;
                    if AllApproved then begin
                        if PurchaseHeader.Get(ApprovalEntry."Document Type", ApprovalEntry."Document No.")then begin
                            PurchaseHeader.CalcFields(Amount);
                            Body+='<tr>' + '<td>' + PurchaseHeader."No." + '</td>' + '<td>' + PurchaseHeader."Buy-from Vendor Name" + '</td>' + '<td>' + Format(PurchaseHeader.Amount) + '</td>' + '</tr>';
                        end;
                        HasApprovedPO:=true;
                    end;
                    ProcessedPOs.Add(POKey, true);
                end;
            until ApprovalEntry.Next() = 0;
        if HasApprovedPO then begin
            Body+='</table><br><br>' + 'Thank you.' + '</body></html>';
            SendApprovedPOEmail(Body, ProcessedPOs);
        end;
    end;
    // local procedure SendApprovedPOEmail(Body: Text)
    // var
    //     Email: Codeunit Email;
    //     EmailMessage: Codeunit "Email Message";
    // begin
    //     EmailMessage.Create(GetNotificationEmail(), 'Approved Purchase Orders', Body, true);
    //     Email.Send(EmailMessage);
    // end;
    local procedure SendApprovedPOEmail(Body: Text; ApprovedPOs: Dictionary of[Text, Boolean])
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        PurchaseHeader: Record "Purchase Header";
        POKey: Text;
        DocumentNo: Code[20];
    begin
        EmailMessage.Create(GetNotificationEmail(), 'Approved Purchase Orders', Body, true);
        foreach POKey in ApprovedPOs.Keys()do begin
            DocumentNo:=CopyStr(POKey, StrPos(POKey, '|') + 1);
            if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, DocumentNo)then begin
                AddPOAttachments(EmailMessage, PurchaseHeader);
            end;
        end;
        Email.Send(EmailMessage);
    end;
    local procedure AddPOAttachments(var EmailMessage: Codeunit "Email Message"; PurchaseHeader: Record "Purchase Header")
    var
        DocumentAttachment: Record "Document Attachment";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        FileName: Text;
    begin
        DocumentAttachment.Reset();
        DocumentAttachment.SetRange("Table ID", Database::"Purchase Header");
        DocumentAttachment.SetRange("Document Type", PurchaseHeader."Document Type");
        DocumentAttachment.SetRange("No.", PurchaseHeader."No.");
        if DocumentAttachment.FindSet()then repeat Clear(TempBlob);
                TempBlob.CreateOutStream(OutStream);
                DocumentAttachment."Document Reference ID".ExportStream(OutStream);
                TempBlob.CreateInStream(InStream);
                FileName:=DocumentAttachment."File Name";
                if DocumentAttachment."File Extension" <> '' then FileName:=FileName + ',' + DocumentAttachment."No." + '.' + DocumentAttachment."File Extension";
                EmailMessage.AddAttachment(FileName, DocumentAttachment."File Extension", InStream);
            until DocumentAttachment.Next() = 0;
    end;
    local procedure GetGreeting(): Text var
        CurrentTime: Time;
    begin
        CurrentTime:=Time;
        if CurrentTime < 120000T then exit('Good Morning')
        else if CurrentTime < 170000T then exit('Good Afternoon')
            else
                exit('Good Evening');
    end;
    local procedure GetNotificationEmail(): Text begin
        //exit('RamakrishnaP@gerabsys.com');
        //exit('KavyaR@gerabsys.com');
        exit('CyrilV@gerabsys.com');
    end;
}
