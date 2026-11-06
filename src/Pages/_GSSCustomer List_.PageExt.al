pageextension 60110 "GSSCustomer List" extends "Customer List"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field(LastBookingDate; LastBookingDate)
            {
                ApplicationArea = All;
            }
            field(LastInvoiceDate; LastInvoiceDate)
            {
                ApplicationArea = All;
            }
            field(GSSTeam; Rec.GSSTeam)
            {
                ApplicationArea = All;
            }
        }
        addafter("Credit Limit (LCY)")
        {
            field("GSSCredit Insurance Limit(LCY)"; Rec."GSSCredit Insurance Limit(LCY)")
            {
                ApplicationArea = All;
            }
            field("Credit Start Date"; Rec."Credit Start Date")
            {
                ApplicationArea = All;
            }
            field("Credit End Date"; Rec."Credit End Date")
            {
                ApplicationArea = All;
            }
            field("Insurance Ref no"; Rec."Insurance Ref no")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(Reports)
        {
            action(GSSCustAgingSummary)
            {
                Caption = 'Customer - Aging Summary';
                ApplicationArea = All;
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    CustAgingSummary: Report "GSSCustomer Aging - Summary";
                begin
                    CustAgingSummary.RunModal();
                end;
            }
            action(GSSCustomerAgingDetailed)
            {
                ApplicationArea = All;
                Caption = 'Customer Aging - Detailed';
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    CustomerAgingDetailed: Report "GSSCustomer Aging - Detailed";
                begin
                    CustomerAgingDetailed.RunModal();
                end;
            }
        }
        addafter(Statement)
        {
            action(GSSStatement2)
            {
                ApplicationArea = All;
                Caption = 'Customer Statement ';
                Image = Report2;

                trigger OnAction()
                var
                    Statement: Report "GSSStatement2";
                begin
                    Statement.RunModal();
                end;
            }
        }
        addafter(ReportCustomerDetailedAging)
        {
        }
        modify(CustAgingDetail)
        {
            Visible = false;
        }
        modify(CustAgingSummary)
        {
            Visible = false;
        }
    }
    trigger OnAfterGetRecord()
    var
        CusLedEntry: Record "Cust. Ledger Entry";
        JobRec: Record Job;
    begin
        Clear(LastBookingDate);
        Clear(LastInvoiceDate);
        CusLedEntry.Reset();
        CusLedEntry.SetCurrentKey("Posting Date");
        CusLedEntry.SetRange("Document Type", CusLedEntry."Document Type"::Invoice);
        CusLedEntry.SetRange("Customer No.", Rec."No.");
        CusLedEntry.SetAscending("Posting Date", false);
        if CusLedEntry.FindFirst()then begin
            LastInvoiceDate:=CusLedEntry."Posting Date";
        end;
        JobRec.Reset;
        JobRec.SetCurrentKey("Creation Date");
        JobRec.SetRange("Bill-to Customer No.", Rec."No.");
        JobRec.SetAscending("Creation Date", false);
        if JobRec.FindFirst()then begin
            LastBookingDate:=JobRec."Creation Date";
        end;
    end;
    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if UserSetup."SalesPerson Filter" <> '' then begin
            Rec.FilterGroup(100);
            Rec.SetFilter("Salesperson Code", UserSetup."SalesPerson Filter");
            Rec.FilterGroup(0);
        end;
    end;
    var LastInvoiceDate: Date;
    LastBookingDate: Date;
    UserSetup: Record "User Setup";
}
