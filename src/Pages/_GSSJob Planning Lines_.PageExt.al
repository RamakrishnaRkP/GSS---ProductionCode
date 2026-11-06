pageextension 60116 "GSSJob Planning Lines" extends "Job Planning Lines"
{
    layout
    {
        addbefore("Planning Date")
        {
            field(CustomerName; JobRec."Sell-to Customer Name")
            {
                ApplicationArea = All;
            }
            field(Salesperson; JobRec."GSSSalesperson Code")
            {
                ApplicationArea = All;
            }
            field("Job Creation Date"; JobRec."Creation Date")
            {
                ApplicationArea = All;
            }
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("Manufacturer Code"; ManuCode)
            {
                ApplicationArea = All;
            }
            field(GSSStatus; Rec.GSSStatus)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
        addafter(Control1)
        {
            field("GSSItem Type"; Rec."GSSItem Type")
            {
                Editable = false;
                Visible = false;
                ApplicationArea = All;
            }
        }
        addafter("Unit Cost")
        {
            field("GSSCurrency Code"; Rec."Currency Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("GSSSupply From"; Rec."GSSSupply From")
            {
                ApplicationArea = All;
            }
            field("GSSSupply From Name"; Rec."GSSSupply From Name")
            {
                ApplicationArea = All;
            }
        }
        addafter("Planned Delivery Date")
        {
            field("GSSRenewal Date"; Rec."GSSRenewal Date")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Quantity)
        {
            field("PO Reference"; Rec."PO Reference")
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    PHdrRec: Record "Purchase Header";
                begin
                    Rec.CalcFields("PO Reference");
                    PHdrRec.Reset();
                    if PHdrRec.Get(PHdrRec."Document Type"::Order, Rec."PO Reference")then begin
                        Page.RunModal(Page::"Purchase Order", PHdrRec);
                    end
                    else
                    begin
                        Message('The Purchase Order cannot be found.');
                    end;
                end;
            }
        }
        addafter("Qty. Posted")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Job Task No.")
        {
            field("GSSGlobal Dimension 1 Code"; Rec."GSSGlobal Dimension 1 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("GSSGlobal Dimension 2 Code"; Rec."GSSGlobal Dimension 2 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        modify("Job Task No.")
        {
            trigger OnBeforeValidate()
            begin
                Rec.TestStatusOpen();
                TestPosted();
            end;
        }
        modify("Line Type")
        {
            trigger OnBeforeValidate()
            begin
                //TestStatusOpen();
                TestPosted();
            end;
        }
        modify("Planning Date")
        {
            trigger OnBeforeValidate()
            begin
            //TestStatusOpen();
            //TestPosted();
            end;
        }
        modify("Planned Delivery Date")
        {
            trigger OnBeforeValidate()
            begin
            //TestStatusOpen();
            //TestPosted();
            end;
        }
        modify("Document No.")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify(Type)
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("No.")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
                TestStatusOpenNew();
            end;
        }
        modify("Variant Code")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify(Description)
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify(Quantity)
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Unit Cost")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Unit Price")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Line Amount")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Line No.")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Job No.")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Direct Unit Cost (LCY)")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Unit of Measure Code")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Location Code")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Work Type Code")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Line Discount %")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Line Discount Amount")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Currency Date")
        {
            trigger OnBeforeValidate()
            begin
                //TestStatusOpen();
                TestPosted();
            end;
        }
        modify("Ledger Entry Type")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
        modify("Ledger Entry No.")
        {
            trigger OnBeforeValidate()
            begin
                TestStatusOpenNew();
                TestPosted();
            end;
        }
    }
    actions
    {
        modify("Create &Sales Invoice")
        {
            trigger OnBeforeAction()
            begin
                JobDocumentClass.TestJobStatusReleased(Rec."Job No.");
            end;
        }
        modify(CreateJobJournalLines)
        {
            trigger OnBeforeAction()
            begin
                JobDocumentClass.TestJobStatusReleased(Rec."Job No.");
            end;
        }
        modify("Create Sales &Credit Memo")
        {
            trigger OnBeforeAction()
            begin
                JobDocumentClass.TestJobStatusReleased(Rec."Job No.");
            end;
        }
    }
    trigger OnAfterGetRecord()
    begin
        Clear(ManuCode);
        if ItemRec.Get(Rec."No.")then ManuCode:=ItemRec."Manufacturer Code";
        if JobRec.Get(Rec."Job No.")then;
    end;
    trigger OnOpenPage()
    begin
        UserSetupRec.Reset();
        if UserSetupRec.Get(UserId)then;
    end;
    procedure TestStatusOpenNew()
    begin
        Rec.CalcFields(GSSStatus);
        Rec.TestField(GSSStatus, Rec.GSSStatus::Open);
    end;
    procedure TestPosted()
    var
        myInt: Integer;
    begin
        if not UserSetupRec."Allow Job Exception" then begin
            Rec.TestField("Qty. Invoiced", 0);
            Rec.TestField("Qty. Posted", 0);
        end;
    end;
    var JobDocumentClass: Codeunit "GSSJob Document Class";
    ItemRec: Record Item;
    UserSetupRec: Record "User Setup";
    ManuCode: Code[10];
    JobRec: Record Job;
}
