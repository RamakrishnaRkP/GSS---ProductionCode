tableextension 60116 "GSSPurchase Header" extends "Purchase Header"
{
    fields
    {
        field(60100; "GSSJob No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            TableRelation = Job."No.";
            ValidateTableRelation = true;
            Editable = false;
        }
        field(60101; "GSSCurrency To Print"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Currency.Code;
            Caption = 'Currency To Print';
        }
        field(60102; "GSSCurrency Exchange Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Currency Exchange Rate';
        }
        field(60103; "Outstanding Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.")));
        }
        field(60104; "Customer Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Job."Sell-to Customer Name" where("No." = field("GSSJob No.")));
        }
        field(60105; "Payment Terms Description"; Text[100])
        {
            Caption = 'Payment Terms';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Payment Terms".Description where(Code = field("Payment Terms Code")));
        }

        ///Rk

        field(60106; "PO Type"; Enum "PO Type")
        {
            Caption = 'PO Type';
            DataClassification = CustomerContent;
        }
    }
}
