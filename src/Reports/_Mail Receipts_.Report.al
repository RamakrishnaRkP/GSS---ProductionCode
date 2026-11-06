report 60181 "Mail Receipts"
{
    Caption = 'Mail Receipts';
    ProcessingOnly = true;
    UseRequestPage = false;
    Permissions = tabledata "Purch. Rcpt. Header"=RIMD;

    dataset
    {
        dataitem(Hdr; "Purch. Rcpt. Header")
        {
            trigger OnAfterGetRecord()
            begin
                SendEmail(Hdr);
            end;
            trigger OnPreDataItem()
            begin
                SetRange("Email Triggered", false);
            end;
        }
    }
    local procedure SendEmail(HdrRec: Record "Purch. Rcpt. Header")
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
        PurchHdr: Record "Purch. Rcpt. Header";
        UserSetup: Record "User Setup";
        UserRec: Record User;
        RefJobRec: Record Job;
        EmailSub: Text;
        SalespeopleRec: Record "Salesperson/Purchaser";
    begin
        Clear(EmailSub);
        crlf:=typehelp.CRLFSeparator();
        Clear(emailTo);
        if RefJobRec.Get(HdrRec."GSSJob No.")then begin
            UserSetup.Reset();
            UserSetup.SetRange("User ID", RefJobRec."Project Manager");
            if UserSetup.FindFirst()then begin
                if cv.ValidateEmail(UserSetup."E-Mail", emailTo) = true then;
                UserRec.SetRange("User Name", UserSetup."User ID");
                if UserRec.FindFirst()then;
                if UserSetup."User ID" = 'SALEEMA' then emailTo.Add('OwaisS@gerab.com');
                if emailTo.Count > 0 then begin
                    Clear(TempBlob);
                    Clear(VarInStreamInv);
                    Clear(VarOutStream);
                    TempBlob.Content.CreateOutStream(VarOutStream);
                    PurchHdr.Reset();
                    PurchHdr.SetRange("No.", HdrRec."No.");
                    if PurchHdr.FindFirst()then begin
                        EmailSub:=PurchHdr."No." + ' - ' + 'Receipt Creation';
                        TempBlob.Content.CreateInStream(VarInStreamInv);
                        txt:='Dear ' + UserRec."Full Name" + ',' + crlf + 'The Receipt ' + PurchHdr."No." + ' has been created.' + crlf + 'Vendor Name - ' + PurchHdr."Buy-from Vendor Name" + crlf + 'Thanks & Regards' + crlf + 'ERP Admin';
                        txt:=cv.TextToHtml(txt);
                        EmailMessage.Create(emailTo, EmailSub, txt, true);
                        if Email.Send(EmailMessage, Enum::"Email Scenario"::"Purchase Order")then begin
                            PurchHdr."Email Triggered":=true;
                            PurchHdr.Modify();
                        end;
                    end;
                end;
            end;
        end;
    end;
}
