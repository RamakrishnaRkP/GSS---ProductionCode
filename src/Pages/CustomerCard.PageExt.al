pageextension 60112 "GSSCustomer Card" extends "Customer Card"
{
    layout
    {

        addbefore("ATOS Status")
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
            }
            field("GSSCreatedBy User"; Rec."GSSCreatedBy User")
            {
                ApplicationArea = All;
            }
            field("GSS Dispute"; Rec."GSS Dispute")
            {
                ApplicationArea = All;
            }
        }
        addafter("Salesperson Code")
        {
            field(GSSTeam; Rec.GSSTeam)
            {
                ApplicationArea = All;
            }
        }
        addafter("Credit Limit (LCY)")
        {
            ////Rk
            field("Reason for Credit Change"; Rec."Reason for Credit Change")
            {
                ApplicationArea = All;
            }
            field("Old Credit Limit"; Rec."Old Credit Limit")
            {
                ApplicationArea = All;
            }
            field("Credit Limit Difference"; Rec."Credit Limit Difference")
            {
                ApplicationArea = All;
            }
            ////Rk
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
        // ----- Customer Name -----
        modify(Name)
        {
            // ShowMandatory makes Business Central display a red asterisk (*) 
            // next to the field label to indicate it is required.
            ShowMandatory = true;
        }

        // ----- Address -----
        modify(Address)
        {
            ShowMandatory = true;
        }

        // ----- Contact Number (Phone No.) -----
        modify("Phone No.")
        {
            ShowMandatory = true;
        }

        // ----- Email ID -----
        modify("E-Mail")
        {
            ShowMandatory = true;
        }

        // ----- Payment Terms -----
        modify("Payment Terms Code")
        {
            ShowMandatory = true;
        }

        // ----- Country/Region -----
        modify("Country/Region Code")
        {
            ShowMandatory = true;
        }

        // ----- Credit Limit -----
        modify("Credit Limit (LCY)")
        {
            ShowMandatory = true;
            trigger OnBeforeValidate()
            begin
                Rec."Previous Credit Limit" := Rec."Credit Limit (LCY)";
                Rec.Modify();
            end;
        }
    }

    actions
    {
        addlast(reporting)
        {
            action(GSSStatement2)
            {
                Caption = 'Customer Statement ';
                ApplicationArea = All;
                Image = Report2;


                trigger OnAction()
                var
                    GSSStatement2: Report "GSSStatement2";
                begin
                    GSSStatement2.RunModal();
                end;

            }
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
        modify(CustAgingDetail)
        {
            Visible = false;
        }
        modify(CustAgingSummary)
        {
            Visible = false;
        }

        ///Rk

        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                Rec."Credit Limit Difference" := Rec."Credit Limit (LCY)" - Rec."Old Credit Limit";
                Rec.Modify()
            end;


        }

        modify(ATOSReopenCustomer)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec."Old Credit Limit" := Rec."Credit Limit (LCY)";
                Rec.Modify();
            end;
        }

    }

    var
        PrevCreditLimit: Decimal;
        LimitCaptured: Boolean;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Customer: Record Customer;
    begin
        // Only validate when the user is saving (OK action) 
        // and the record is new or modified.
        if CloseAction in [ACTION::OK, ACTION::LookupOK] then begin
            Customer := Rec;
            if Customer.Name = '' then begin
                Message('Warning: Customer Name is mandatory and has not been filled in.');
                exit(false);
            end;
            if Customer.Address = '' then begin
                Message('Warning: Address is mandatory and has not been filled in.');
                exit(false);
            end;
            if Customer.Contact = '' then begin
                Message('Warning: Contact Person is mandatory and has not been filled in.');
                exit(false);
            end;
            if Customer."Phone No." = '' then begin
                Message('Warning: Contact Number is mandatory and has not been filled in.');
                exit(false);
            end;
            if Customer."E-Mail" = '' then begin
                Message('Warning: Email ID is mandatory and has not been filled in.');
                exit(false);
            end;
            if Customer."Payment Terms Code" = '' then begin
                Message('Warning: Payment Terms is mandatory and has not been filled in.');
                exit(false);
            end;
            if Customer."Country/Region Code" = '' then begin
                Message('Warning: Country/Region is mandatory and has not been filled in.');
                exit(false);
            end;
            //  if Customer."Credit Limit (LCY)" <= 0 then begin
            //   Message('Warning: Credit Limit is mandatory. Please enter a value greater than 0.');
            //  exit(false);
            //  end;
        end;
        exit(true);
    end;
}
