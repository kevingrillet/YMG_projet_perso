unit ProjetPerso.Images;

interface

uses
   System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls;

const
   // Les images suivant l'état de la LED
   CST_IMG_OFF = 0;
   CST_IMG_GREEN = 1;
   CST_IMG_YELLOW = 2;
   CST_IMG_RED = 3;
   CST_IMG_WARN = 5;

type
   TdmImages = class(TDataModule)
      imageList16: TImageList;
      imageList32: TImageList;
   end;

var
   dmImages: TdmImages;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

end.
