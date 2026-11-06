report 60180 "Mail Jobs"
{
    Caption = 'Mail Jobs';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(Job; Job)
        {
            trigger OnAfterGetRecord()
            begin
                SendEmail(Job);
            end;
            trigger OnPreDataItem()
            begin
                SetRange("Email Triggered", false);
                SetRange(GSSStatus, GSSStatus::Released);
            end;
        }
    }
    local procedure SendEmail(JobRec: Record Job)
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        TempBlob: Record "Tenant Media" temporary;
        VarOutStreamInv: OutStream;
        VarInStreamInv: InStream;
        AttachmentName: Text[250];
        VarOutStream: OutStream;
        emailTo: List of[Text];
        Salesperson: record "Salesperson/Purchaser";
        cv: Codeunit ARM_CustomValidator;
        txt: Text;
        typehelp: Codeunit "Type Helper";
        crlf: Text[2];
        NewJobRec: Record Job;
        UserSetup: Record "User Setup";
        UserRec: Record User;
        EmailSub: Text;
        SalespeopleRec: Record "Salesperson/Purchaser";
    begin
        crlf:=typehelp.CRLFSeparator();
        Clear(emailTo);
        Clear(EmailSub);
        UserSetup.Reset();
        UserSetup.SetRange("User ID", JobRec."Project Manager");
        if UserSetup.FindFirst()then begin
            if cv.ValidateEmail(UserSetup."E-Mail", emailTo) = true then;
            UserRec.SetRange("User Name", UserSetup."User ID");
            if UserRec.FindFirst()then;
            if UserSetup."User ID" = 'SALEEMA' then begin
                emailTo.Add('OwaisS@gerabsys.com');
                emailTo.Add('paridhim@gerabsys.com');
            end;
            if emailTo.Count > 0 then begin
                Clear(TempBlob);
                Clear(VarInStreamInv);
                Clear(VarOutStream);
                TempBlob.Content.CreateOutStream(VarOutStream);
                NewJobRec.Reset();
                NewJobRec.SetRange("No.", JobRec."No.");
                if NewJobRec.FindFirst()then begin
                    if SalespeopleRec.Get(NewJobRec."GSSSalesperson Code")then;
                    EmailSub:=NewJobRec."No." + ' - ' + 'Job Assignment';
                    TempBlob.Content.CreateInStream(VarInStreamInv);
                    txt:='Dear ' + UserRec."Full Name" + ',' + crlf + 'The Job ' + NewJobRec."No." + ' has been assigned to you.' + crlf + 'Customer Name - ' + NewJobRec."Sell-to Customer Name" + crlf + 'Job Description - ' + NewJobRec.Description + crlf + 'Salesperson - ' + SalespeopleRec.Name + crlf + 'Thanks & Regards' + crlf + 'ERP Admin';
                    txt:=cv.TextToHtml(txt);
                    EmailMessage.Create(emailTo, EmailSub, txt, true);
                    if Email.Send(EmailMessage, Enum::"Email Scenario"::"Job Planning Line Calendar")then begin
                        NewJobRec."Email Triggered":=true;
                        NewJobRec.Modify();
                    // Message('Email Sent Successfully');
                    end;
                end;
            end;
        end;
    end;
}
