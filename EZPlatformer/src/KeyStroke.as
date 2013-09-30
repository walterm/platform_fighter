package  
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.external.ExternalInterface;
	import flash.text.TextField;		
	
	public class KeyStroke extends Sprite 
	{
		
		private var tf:TextField;
		
		public function KeyStroke()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			tf = addChild(new TextField()) as TextField;	
			tf.autoSize = 'left';
			
			if(ExternalInterface.available)
			{
				if(ExternalInterface.addCallback("flashLog", setMessage))
				{	
					tf.text = "addCallback() failed :(";
				}
				else
				{	
					tf.text = "flash waiting";
				}
			}
			else
			{
				setMessage("ExternalInterface not available!");
			}
		}
		
		
		private function setMessage(...params):void
		{
			tf.text = "message : " + params.toString();
		}
	}
}