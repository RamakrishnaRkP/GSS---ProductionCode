report 60150 "Customer Credit Check"
{
    Caption = 'Customer Credit Check';
    ProcessingOnly = true;
    UseRequestPage = false;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.")
            {
            }
            trigger OnAfterGetRecord()
            begin
                Clear(DueDays);
                CustLedEntry.SetCurrentKey("Posting Date");
                CustLedEntry.SetRange("Customer No.", Customer."No.");
                CustLedEntry.SetRange(Open, true);
                CustLedEntry.SetFilter("Due Date", '<%1', WorkDate);
                CustLedEntry.SetAscending("Posting Date", true);
                if CustLedEntry.FindFirst()then begin
                    DueDays:=Today - CustLedEntry."Due Date";
                // Message('Today-%1...DueDate-%2...Days-%3...Customer-%4', Today, CustLedEntry."Due Date", DueDays, Customer."No.");
                end;
                if DueDays > 30 then begin
                    Customer.Blocked:=Customer.Blocked::All;
                    if MailCustomers = '' then MailCustomers:=Customer."No."
                    else
                        MailCustomers:=MailCustomers + ',' + Customer."No.";
                    Customer.Modify();
                end
                else
                begin
                    Customer.Blocked:=Customer.Blocked::" ";
                    Customer.Modify();
                end;
            end;
            trigger OnPreDataItem()
            begin
                Customer.SetFilter("Customer Posting Group", '=%1', 'DEBTORS');
                Clear(MailCustomers);
            end;
        }
    }
    trigger OnPostReport()
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
    begin
        if MailCustomers <> '' then begin
            Clear(MailTo);
            Clear(AttachmentName);
            // if UserRec.Get('DEVENK') then
            MailTo:='DevenK@ampconnectme.com'; //UserRec."Contact Email";
            if MailCustomers <> '' then MailCustomers:=MailCustomers + '. These customers are blocked';
            Subject:='Blocked Customers ' + Format(Today);
        // EmailMessage.Create(MailTo, Subject, Subject);
        // if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
        //    Message('Notified Finance User');
        //  if mail.EmailFileFromStream(Istream, AttachmentName, MailCustomers, Subject, MailTo, true, 4) then
        end;
    end;
    var CustLedEntry: Record "Cust. Ledger Entry";
    DueDays: Integer;
    MailCustomers: Text;
    AttachmentName: Text[100];
    MailTo: Text;
    OStream: OutStream;
    IStream: InStream;
    Mail: Codeunit "Document-Mailing";
    UserRec: Record User;
    Subject: Text;
}
