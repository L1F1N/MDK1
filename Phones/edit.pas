unit Edit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TfEdit }

  TfEdit = class(TForm)
    bSave: TBitBtn;
    BitBtn2: TBitBtn;
    eJanr: TEdit;
    eName: TEdit;
    eKod: TEdit;
    eGod: TEdit;
    eAvtor: TEdit;
    KodL: TLabel;
    NazvanieL: TLabel;
    AvtorL: TLabel;
    JanrL: TLabel;
    GodL: TLabel;
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  fEdit: TfEdit;

implementation

{$R *.lfm}

{ TfEdit }

procedure TfEdit.FormShow(Sender: TObject);
begin
  eKod.SetFocus;
end;

end.

