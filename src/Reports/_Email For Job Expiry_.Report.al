report 60169 "Email For Job Expiry"
{
    Caption = 'Send Email For Job Expiry';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Job; Job)
        {
            trigger OnAfterGetRecord()
            var
                txt: Text;
                EmailMessage: Codeunit "Email Message";
                Email: Codeunit Email;
                cv: Codeunit ARM_CustomValidator;
                emailTo: List of[Text];
                crlf: Text[2];
                typehelp: Codeunit "Type Helper";
                GLSetup: Record "General Ledger Setup";
                SalespeoplRec: Record "Salesperson/Purchaser";
                Emails: Text[250];
            begin
                if(((Job."Ending Date" - Today) = 60) or ((Job."Ending Date" - Today) = 30))then begin
                    crlf:=typehelp.CRLFSeparator();
                    Clear(emailTo);
                    GLSetup.Get();
                    SalespeoplRec.Get(Job."GSSSalesperson Code");
                    GLSetup.TestField(JobExpiryNotificationEmail);
                    Clear(Emails);
                    Emails:=GLSetup.JobExpiryNotificationEmail + ';' + SalespeoplRec."E-Mail";
                    if cv.ValidateEmail(Emails, emailTo) = true then;
                    if emailTo.Count > 0 then begin
                        txt:='Dear Team ' + ',' + crlf + 'The Job ' + Job."No." + ' is going to expire in ' + Format(Job."Ending Date" - Today) + ' Days.' + crlf + 'Expiry Date : ' + Format(Job."Ending Date") + crlf + 'Thanks & Regards' + crlf + 'ERP Admin';
                        txt:=cv.TextToHtml(txt);
                        EmailMessage.Create(emailTo, 'Reminder: Job Expiry', txt, true);
                        if Email.Send(EmailMessage, Enum::"Email Scenario"::Notification)then begin
                        end;
                    end;
                end;
            end;
            trigger OnPreDataItem()
            var
            begin
                Job.SetFilter("Ending Date", '<>%1', 0D);
            end;
        }
    }
}
