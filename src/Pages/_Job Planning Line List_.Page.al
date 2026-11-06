page 60130 "Job Planning Line List"
{
    Caption = 'Project Planning Lines';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Job Planning Line";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the planning line''s entry number.';
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the related project.';
                }
                field("Planning Date"; Rec."Planning Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the planning line.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a document number for the planning line.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of account to which the planning line relates.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the resource, item, or G/L account.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the resource, item, or G/L account.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of units on the planning line.';
                }
                field("Direct Unit Cost (LCY)"; Rec."Direct Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the direct unit cost in LCY.';
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost in LCY.';
                }
                field("Total Cost (LCY)"; Rec."Total Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total cost in LCY.';
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit price in LCY.';
                }
                field("Total Price (LCY)"; Rec."Total Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total price in LCY.';
                }
                field("Resource Group No."; Rec."Resource Group No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the resource group number.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how each unit is measured.';
                }
                field("Qty. Rounding Precision"; Rec."Qty. Rounding Precision")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity rounding precision.';
                }
                field("Qty. Rounding Precision (Base)"; Rec."Qty. Rounding Precision (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base quantity rounding precision.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a location code for an item.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the line was last modified.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who last modified the entry.';
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies which work type the resource applies to.';
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer price group.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country/region code.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the general business posting group.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the general product posting group.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document date.';
                }
                field("Planning Due Date"; Rec."Planning Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the planning due date.';
                }
                field("Qty. to Assemble"; Rec."Qty. to Assemble")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity to supply by assembly.';
                }
                field("Qty. to Assemble (Base)"; Rec."Qty. to Assemble (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base quantity to assemble.';
                }
                field("Assemble to Order"; Rec."Assemble to Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the line is assemble-to-order.';
                }
                field("BOM Item No."; Rec."BOM Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BOM item number.';
                }
                field("Attached to Line No."; Rec."Attached to Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line this line is attached to.';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the related project task.';
                }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line amount in LCY.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost.';
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total cost for the planning line.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit price.';
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total price in the project currency.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount that will be posted to the project ledger.';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount amount granted for the item.';
                }
                field("Line Discount Amount (LCY)"; Rec."Line Discount Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount amount in LCY.';
                }
                field("Cost Factor"; Rec."Cost Factor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cost factor.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the serial number applied to the posted item.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lot number applied to the posted item.';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount percentage granted for the item.';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of planning line.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the currency used on the entry.';
                }
                field("Currency Date"; Rec."Currency Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date used to find the exchange rate.';
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the currency factor.';
                }
                field("Schedule Line"; Rec."Schedule Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this is a budget line.';
                }
                field("Contract Line"; Rec."Contract Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this is a billable line.';
                }
                field("Job Contract Entry No."; Rec."Job Contract Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number linked to the sales line.';
                }
                field("Invoiced Amount (LCY)"; Rec."Invoiced Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invoiced amount in LCY.';
                }
                field("Invoiced Cost Amount (LCY)"; Rec."Invoiced Cost Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invoiced cost amount in LCY.';
                }
                field("VAT Unit Price"; Rec."VAT Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit price including VAT.';
                }
                field("VAT Line Discount Amount"; Rec."VAT Line Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line discount amount including VAT.';
                }
                field("VAT Line Amount"; Rec."VAT Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line amount including VAT.';
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT percentage.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional description information.';
                }
                field("Job Ledger Entry No."; Rec."Job Ledger Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the related project ledger entry number.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of a project order.';
                }
                field("Ledger Entry Type"; Rec."Ledger Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry type of the associated project ledger entry.';
                }
                field("Ledger Entry No."; Rec."Ledger Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number of the associated project ledger entry.';
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the entry was created automatically by Business Central.';
                }
                field("Usage Link"; Rec."Usage Link")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether usage entries are linked to the planning line.';
                }
                field("Remaining Qty."; Rec."Remaining Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remaining quantity to complete the project.';
                }
                field("Remaining Qty. (Base)"; Rec."Remaining Qty. (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remaining base quantity.';
                }
                field("Remaining Total Cost"; Rec."Remaining Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remaining total cost for the planning line.';
                }
                field("Remaining Total Cost (LCY)"; Rec."Remaining Total Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remaining total cost in LCY.';
                }
                field("Remaining Line Amount"; Rec."Remaining Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remaining amount to be posted.';
                }
                field("Remaining Line Amount (LCY)"; Rec."Remaining Line Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remaining amount in LCY.';
                }
                field("Qty. Posted"; Rec."Qty. Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity posted to the project ledger.';
                }
                field("Qty. to Transfer to Journal"; Rec."Qty. to Transfer to Journal")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity to transfer to the project journal.';
                }
                field("Posted Total Cost"; Rec."Posted Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total cost posted to the project ledger.';
                }
                field("Posted Total Cost (LCY)"; Rec."Posted Total Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posted total cost in LCY.';
                }
                field("Posted Line Amount"; Rec."Posted Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount posted to the project ledger.';
                }
                field("Posted Line Amount (LCY)"; Rec."Posted Line Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posted line amount in LCY.';
                }
                field("Qty. Transferred to Invoice"; Rec."Qty. Transferred to Invoice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity transferred to a sales invoice or credit memo.';
                }
                field("Qty. to Transfer to Invoice"; Rec."Qty. to Transfer to Invoice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity to transfer to the sales invoice or credit memo.';
                }
                field("Qty. Invoiced"; Rec."Qty. Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity posted through a sales invoice.';
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity remaining to be invoiced.';
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of the item reserved for the line.';
                }
                field("Reserved Qty. (Base)"; Rec."Reserved Qty. (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reserved base quantity.';
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether items on the line can be reserved.';
                }
                field(Planned; Rec.Planned)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the line is fully planned.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the variant of the item on the line.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bin where the item will be put away or picked.';
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity per unit of measure.';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base unit of measure quantity.';
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the requested delivery date.';
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the promised delivery date.';
                }
                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the item or resource is planned to be delivered.';
                }
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the package number.';
                }
                field("Price Calculation Method"; Rec."Price Calculation Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the method used for price calculation.';
                }
                field("Cost Calculation Method"; Rec."Cost Calculation Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the method used for cost calculation.';
                }
                field("Pick Qty."; Rec."Pick Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity picked for the line.';
                }
                field("Qty. Picked"; Rec."Qty. Picked")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of the item picked for the line.';
                }
                field("Qty. Picked (Base)"; Rec."Qty. Picked (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base quantity picked.';
                }
                field("Completely Picked"; Rec."Completely Picked")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the line is completely picked.';
                }
                field("Pick Qty. (Base)"; Rec."Pick Qty. (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base pick quantity.';
                }
                field("Qty. on Journal"; Rec."Qty. on Journal")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity on the project journal.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity on the project journal.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity on the project journal.';
                }
                field("Creation Date"; CreationDateTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the project was created.';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        Job: Record Job;
    begin
        Clear(CreationDateTime);
        if Job.Get(Rec."Job No.")then CreationDateTime:=Job."Creation Date";
    end;
    var CreationDateTime: Date;
}
