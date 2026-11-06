pageextension 60113 "GSSJob List" extends "Job List"
{
    layout
    {
        addbefore(Description)
        {
            field("Creation Date"; Rec."Creation Date")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Opportunity ID"; Rec."Opportunity ID")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("GSSTotal Budgeted Cost"; Rec."GSSTotal Budgeted Cost")
            {
                ApplicationArea = All;
            }
            field("GSSTotal Budgeted Price"; Rec."GSSTotal Budgeted Price")
            {
                ApplicationArea = All;
            }
            field("GSSTotal Billable Price"; Rec."GSSTotal Billable Price")
            {
                ApplicationArea = All;
            }
            field(GSSStatus; Rec.GSSStatus)
            {
                ApplicationArea = All;
            }
            field("GSSWIP Calc. Required"; Rec."GSSWIP Calc. Required")
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
        addafter("Person Responsible")
        {
            field("GSSSalesperson Code"; Rec."GSSSalesperson Code")
            {
                ApplicationArea = All;
            }
            field(GSSTeam; Rec.GSSTeam)
            {
                ApplicationArea = All;
            }
        }
        addafter("Bill-to Customer No.")
        {
            field("Bill to Customer Name"; Rec."Bill-to Name")
            {
                ApplicationArea = all;
            }
            field("GSSExternal Document No."; Rec."GSSExternal Document No.")
            {
                ApplicationArea = All;
                Enabled = false;
                Visible = false;
            }
            field("GSS_External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
            field("GSSPurchaseOrderAmount"; Rec."GSSCustomer PO Amount")
            {
                ApplicationArea = All;
            }
        }
        addafter("GSSTotal Billable Price")
        {
            field("GSSGross Margin "; Rec."GSSGross Margin")
            {
                ApplicationArea = all;
            }
            field("GSSGross Margin %"; Rec."GSSGross Margin %")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        //Calculate WIP
        modify("<Action151>")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestStatusReleased();
            end;
        }
        //Post WIP to GL
        modify("<Action152>")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestStatusReleased();
            end;
        }
        addafter("Send Job Quote")
        {
            action(GSSProformaInvoice)
            {
                Caption = 'Proforma Invoice';
                Image = Report2;
                ApplicationArea = ALL;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    PI: Report GSSProformaInvoice;
                    JOB: Record "Job";
                begin
                    CurrPage.SetSelectionFilter(JOB);
                    PI.SetTableView(Job);
                    PI.RunModal();
                end;
            }
        }
        addlast(processing)
        {
            action(GSSUpdateExternalDocNo)
            {
                Caption = 'Update Job Values';
                Image = Process;
                ApplicationArea = ALL;
                Visible = true;

                trigger OnAction()
                var
                    JobRec: Record Job;
                    JobTaskLineRec: Record "Job Task";
                begin
                    /*  JobRec.Reset();
                     JobRec.SetFilter("No.", '<>%1', '');
                     JobRec.SetFilter("Customer Credit Limit", '=%1', 0);
                     if JobRec.FindSet() then
                         repeat
                             UpdateCU.UpdateSalesValue(JobRec);
                         until JobRec.Next() = 0;

                     SalesHeaderRec.Reset();
                     SalesHeaderRec.SetFilter("GSSJob No.", '<>%1', '');
                     if SalesHeaderRec.FindSet() then
                         repeat
                             UpdateCU.UpdateInvoiceValue(SalesHeaderRec);
                         until SalesHeaderRec.Next() = 0 */
                    JobRec.Reset();
                    JobRec.SetRange(Status, JobRec.Status::Open);
                    if JobRec.FindSet()then repeat JobTaskLineRec.SetRange("Job No.", JobRec."No.");
                            if JobTaskLineRec.FindSet()then repeat JobTaskLineRec.Validate("WIP-Total", JobTaskLineRec."WIP-Total"::Total);
                                    JobTaskLineRec.Modify();
                                until JobTaskLineRec.Next() = 0;
                        until JobRec.Next() = 0;
                end;
            }
            action(Test)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    JPLRec: Record "Job Planning Line";
                begin
                    JPLRec.SetFilter("Job No.", '=%1', 'DXB-SO-2023-00164');
                    if JPLRec.FindFirst()then begin
                        JPLRec.Delete();
                        Commit();
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if UserSetup."SalesPerson Filter" <> '' then begin
            Rec.FilterGroup(100);
            Rec.SetFilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
            Rec.FilterGroup(0);
        end;
    end;
    trigger OnAfterGetRecord()
    var
        CustRec: Record Customer;
    begin
        UserSetup.Get(UserId);
        if not UserSetup."Admin User" then begin
            if CustRec.Get(Rec."Sell-to Customer No.")then begin
                CustRec.CalcFields("Balance (LCY)", "Balance Due (LCY)");
                Rec.Cust_BalanceLCY:=CustRec."Balance (LCY)";
                Rec.Cust_BalanceDueLCY:=CustRec."Balance Due (LCY)";
                Rec.Modify();
            end;
        end;
    end;
    var UserSetup: Record "User Setup";
}
