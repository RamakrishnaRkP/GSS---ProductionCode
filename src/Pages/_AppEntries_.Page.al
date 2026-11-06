page 60176 "AppEntries"
{
    PageType = API;
    Caption = 'ApprovalEntries';
    APIPublisher = 'GSS';
    APIGroup = 'ApprovalEntries';
    APIVersion = 'v1.0';
    EntityName = 'ApprovalEntries';
    EntitySetName = 'ApprovalEntries';
    SourceTable = "Approval Entry";
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Entry_No; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Table_ID; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
                field(Approval_Code; Rec."Approval Code")
                {
                    ApplicationArea = All;
                }
                field(Document_Type; DocType)
                {
                    ApplicationArea = All;
                }
                field(Document_No; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Sequence_No; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                }
                field(Sender_ID; Rec."Sender ID")
                {
                    ApplicationArea = All;
                }
                field(Approver_ID; Rec."Approver ID")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Date_Time_Sent_for_Approval; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = All;
                }
                field(Due_Date; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field(Last_Date_Time_Modified; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = All;
                }
                field(Last_Modified_By_User_ID; Rec."Last Modified By User ID")
                {
                    ApplicationArea = All;
                }
                field(Overdue; Rec.IsOverdue)
                {
                    ApplicationArea = All;
                }
                field(Record_ID_to_Approve; Rec."Record ID to Approve")
                {
                    ApplicationArea = All;
                }
                field(Pending_Approvals; Rec."Pending Approvals")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Date__Sent_for_Approval; DT2Date(Rec."Date-Time Sent for Approval"))
                {
                    ApplicationArea = All;
                }
                field(Approval_Comment; Rec.Approval_Comment)
                {
                    ApplicationArea = All;
                }
                field(DocumentDate; DocDate)
                {
                    ApplicationArea = All;
                }
                field(Notified; Rec.Notified)
                {
                    ApplicationArea = All;
                }
                field(ApproverEmail; ApproverEmail)
                {
                    ApplicationArea = All;
                }
                field(SenderEmail; SenderEmail)
                {
                    ApplicationArea = All;
                }
                field(CustomerName; CustomerName)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Salesperson; Salesperson)
                {
                    ApplicationArea = All;
                }
                field(OrderAmount; OrderAmount)
                {
                    ApplicationArea = All;
                }
                field(GP; GP)
                {
                    ApplicationArea = All;
                }
                field(GPPercent; GPPercent)
                {
                    ApplicationArea = All;
                }
                field(CurrencyCode; CurrCode)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        RecRef: RecordRef;
        Job: Record Job;
    begin
        Clear(DocDate);
        Clear(CustomerName);
        Clear(Description);
        Clear(Salesperson);
        Clear(OrderAmount);
        Clear(GP);
        Clear(GPPercent);
        Clear(CurrCode);
        Clear(ApproverEmail);
        Clear(SenderEmail);
        Clear(DocType);
        GenLedSetup.Get();
        PurHdr.SetRange("No.", Rec."Document No.");
        if PurHdr.FindFirst()then begin
            DocDate:=PurHdr."Document Date";
        end;
        SalHdr.Reset();
        SalHdr.SetRange("No.", Rec."Document No.");
        if SalHdr.FindFirst()then begin
            DocDate:=SalHdr."Document Date";
        end;
        if ApproverUserSetup.Get(Rec."Approver ID")then ApproverEmail:=ApproverUserSetup."E-Mail";
        if SenderUserSetup.Get(Rec."Sender ID")then SenderEmail:=SenderUserSetup."E-Mail";
        case Rec."Table ID" of 167: begin
            RecRef.Get(Rec."Record ID to Approve");
            RecRef.SetTable(Job);
            // if Job.Get(Rec."Document No.") then begin
            Job.CalcFields("GSSTotal Budgeted Price");
            CustomerName:=Job."Sell-to Customer Name";
            Description:=Job."Search Description";
            OrderAmount:=Job."GSSTotal Budgeted Price";
            GP:=Job."GSSGross Margin";
            GPPercent:=Job."GSSGross Margin %";
            if SalespersonRec.Get(Job."GSSSalesperson Code")then Salesperson:=SalespersonRec.Name;
            if Job."Currency Code" = '' then CurrCode:=GenLedSetup."LCY Code"
            else
                CurrCode:=Job."Currency Code";
            // end;
            DocType:='JOB';
        end;
        end;
    end;
    var PurHdr: Record "Purchase Header";
    SalHdr: Record "Sales Header";
    SalespersonRec: Record "Salesperson/Purchaser";
    ApproverUserSetup: Record "User Setup";
    SenderUserSetup: Record "User Setup";
    Job: Record Job;
    DocDate: Date;
    CustomerName: Text[250];
    Description: Text[250];
    Salesperson: Text[100];
    OrderAmount: Decimal;
    GP: Decimal;
    GPPercent: Decimal;
    CurrCode: Code[20];
    GenLedSetup: Record "General Ledger Setup";
    ApproverEmail: Text[100];
    SenderEmail: Text[100];
    DocType: Text;
}
