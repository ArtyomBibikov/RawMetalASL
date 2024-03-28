state("Raw Metal") {}

startup
{

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Raw Metal";
	vars.Helper.LoadSceneManager = true;
	
	settings.Add("RM", true, "Raw Metal");
		settings.Add("ANYAL", true, "Any% All Levels", "RM");
			settings.Add("L1F1", true, "L1F1", "ANYAL");
			settings.Add("L1F2", true, "L1F2", "ANYAL");
			settings.Add("L1F3", true, "L1F3", "ANYAL");
			settings.Add("L1FB", true, "L1FB", "ANYAL");
			settings.Add("L2F1", true, "L2F1", "ANYAL");
			settings.Add("L2F2", true, "L2F2", "ANYAL");
			settings.Add("L2F3", true, "L2F3", "ANYAL");
			settings.Add("L2FB", true, "L2FB", "ANYAL");
			settings.Add("L3F1", true, "L3F1", "ANYAL");
			settings.Add("L3F2", true, "L3F2", "ANYAL");
			settings.Add("L3F3", true, "L3F3", "ANYAL");
			settings.Add("L3FB", true, "L3FB", "ANYAL");
			settings.Add("L4F1", true, "L4F1", "ANYAL");
	
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
	vars.Splits = new HashSet<string>();
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
	if(old.loadlvl != current.loadlvl && current.ascending == false)
	{
		return vars.Splits.Add(old.loadlvl) && settings[old.loadlvl];
	}
	else return current.elepunch != old.elepunch || current.Scene == "Escape Success Screen" && old.Scene != current.Scene;
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
