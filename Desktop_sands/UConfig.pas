unit UConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Label7: TLabel;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses UMain;

procedure TForm2.FormShow(Sender: TObject);
begin
 ShowWindow(Application.Handle,SW_HIDE);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
 close;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
 close;
end;

end.
