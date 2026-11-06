pageextension 60170 "Purch. Order Sub Ext" extends "Purchase Order Subform"
{
    layout
    {
        modify(Type)
        {
            StyleExpr = Colour;
        }
        modify("No.")
        {
            StyleExpr = Colour;
        }
        modify(Description)
        {
            StyleExpr = Colour;
        }
        modify("Location Code")
        {
            StyleExpr = Colour;
        }
        modify("Bin Code")
        {
            StyleExpr = Colour;
        }
        modify(Quantity)
        {
            StyleExpr = Colour;
        }
        modify("Reserved Quantity")
        {
            StyleExpr = Colour;
        }
        modify("Unit of Measure")
        {
            StyleExpr = Colour;
        }
        modify("Unit of Measure Code")
        {
            StyleExpr = Colour;
        }
        modify("Direct Unit Cost")
        {
            StyleExpr = Colour;
        }
        modify("Line Amount")
        {
            StyleExpr = Colour;
        }
        modify("Line Discount Amount")
        {
            StyleExpr = Colour;
        }
        modify("Qty. to Receive")
        {
            StyleExpr = Colour;
        }
        modify("Qty. to Invoice")
        {
            StyleExpr = Colour;
        }
        modify("Quantity Received")
        {
            StyleExpr = Colour;
        }
        modify("Quantity Invoiced")
        {
            StyleExpr = Colour;
        }
        modify("Shortcut Dimension 1 Code")
        {
            StyleExpr = Colour;
        }
        modify("Shortcut Dimension 2 Code")
        {
            StyleExpr = Colour;
        }
        modify(ShortcutDimCode3)
        {
            StyleExpr = Colour;
        }
        modify(ShortcutDimCode4)
        {
            StyleExpr = Colour;
        }
        modify("Planned Receipt Date")
        {
            StyleExpr = Colour;
        }
        modify("Expected Receipt Date")
        {
            StyleExpr = Colour;
        }
    }
    trigger OnAfterGetRecord()
    begin
        if Rec.Modified then begin
            Colour:='attention';
        end
        else
            Colour:='standard';
    end;
    trigger OnModifyRecord(): Boolean begin
        if Rec.Reopened then begin
            Rec.Modified:=true;
            Rec.Modify();
        end;
        CurrPage.Update(false);
    end;
    var Colour: Text;
}
