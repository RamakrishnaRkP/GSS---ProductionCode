report 60185 "Mail Opportunites"
{
    Caption = 'Mail Opportunities';
    ProcessingOnly = true;
    UseRequestPage = false;
    Permissions = tabledata Opportunity=RIMD;

    dataset
    {
        dataitem(Opportunity; Opportunity)
        {
            trigger OnAfterGetRecord()
            begin
                SendEmail(Opportunity);
            end;
            trigger OnPreDataItem()
            begin
                SetRange("Email Triggered", false);
                SetFilter("Global Dimension 1 Code", '<>%1', '');
            end;
        }
    }
    local procedure SendEmail(OppRec: Record Opportunity)
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
        NewOppRec: Record Opportunity;
        UserSetup: Record "User Setup";
        UserRec: Record User;
        EmailSub: Text;
        DimensionValue: Record "Dimension Value";
        SalespeopleRec: Record "Salesperson/Purchaser";
        GlobalContact: Record Contact;
        URL: Text;
    begin
        crlf:=typehelp.CRLFSeparator();
        Clear(emailTo);
        Clear(EmailSub);
        URL:=GetUrl(ClientType::Web, CompanyName, ObjectType::Page, 5124, OppRec, false);
        UserSetup.Reset();
        UserSetup.SetRange("Global Dimension 1 Code", OppRec."Global Dimension 1 Code");
        if UserSetup.FindSet()then repeat emailTo.Add(UserSetup."E-Mail");
            until UserSetup.Next() = 0;
        UserRec.SetRange("User Name", UserSetup."User ID");
        if UserRec.FindFirst()then;
        if emailTo.Count > 0 then begin
            Clear(TempBlob);
            Clear(VarInStreamInv);
            Clear(VarOutStream);
            TempBlob.Content.CreateOutStream(VarOutStream);
            NewOppRec.Reset();
            NewOppRec.SetRange("No.", OppRec."No.");
            if NewOppRec.FindFirst()then begin
                NewOppRec.CalcFields("Contact Name", "Contact Company Name", "Estimated Closing Date", "Estimated Value (LCY)");
                GlobalContact.GetOrClear(NewOppRec."Contact No.");
                if SalespeopleRec.Get(NewOppRec."Salesperson Code")then;
                EmailSub:=NewOppRec."No." + ' - ' + 'Opportunity Creation';
                TempBlob.Content.CreateInStream(VarInStreamInv);
                txt:='Dear ' + UserRec."Full Name" + ',' + crlf + 'This is to Notify you that an Opportunity ' + NewOppRec."No." + ' is created' + crlf + '<b>Customer Name - </b>' + NewOppRec."Contact Name" + crlf + '<b>Company Name - </b>' + NewOppRec."Contact Company Name" + crlf + '<b>Opportunity Description - </b>' + NewOppRec.Description + crlf + '<b>Salesperson - </b>' + SalespeopleRec.Name + crlf + '<b>Estimated Closure Date - </b>' + Format(NewOppRec."Estimated Closing Date") + crlf + '<b>Estimated Value - </b>' + Format(NewOppRec."Estimated Value (LCY)") + crlf + '<b>Link to Opportunity - </b>' + URL + crlf + 'Thanks & Regards' + crlf + 'ERP Admin';
                txt:=cv.TextToHtml(txt);
                EmailMessage.Create(emailTo, EmailSub, txt, true);
                if Email.Send(EmailMessage, Enum::"Email Scenario"::Notification)then begin
                    NewOppRec."Email Triggered":=true;
                    NewOppRec.Modify();
                end;
            end;
        end;
    end;
}
