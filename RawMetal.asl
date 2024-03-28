state("Raw Metal") {}

startup
{

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Raw Metal";
	vars.Helper.LoadSceneManager = true;
	
	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Raw Metal",
            MessageBoxButtons.YesNo, MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
		vars.Helper["loading"] = mono.Make<bool>("LevelLoader", "instance", "IsLoading");
		vars.Helper["paused"] = mono.Make<bool>("GameManager", "instance", "paused");
		vars.Helper["ascending"] = mono.Make<bool>("LevelLoader", "instance", "IsAscending");
		vars.Helper["elepunch"] = mono.Make<bool>("GameManager", "instance", "player", "mitrikTimer", "stopped");
		vars.Helper["loadlvl"] = mono.MakeString("LevelLoader", "instance", "LoadingLevel");
		
		return true;
    });
	current.Scene = "";
}

update
{
	current.Scene = vars.Helper.Scenes.Active.Name;
}

split
{
  return current.elepunch || old.loadlvl != current.loadlvl && current.ascending == false || current.Scene == "Escape Success Screen" && old.Scene != current.Scene;
}

start {    
	return current.Scene == "Elevator";
}

reset {
	return current.Scene == "Title Screen";
}

isLoading {
	return current.loading == true || current.paused == true;
}

exit
{
    vars.Unity.Reset();
}

shutdown
{
    vars.Unity.Reset();
}
