using AspNetCoreHero.ToastNotification.Abstractions;
using AspNetWebApp.Web.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace AspNetWebApp.Web.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly INotyfService _notyf;

        public HomeController(ILogger<HomeController> logger, INotyfService notyf)
        {
            _logger = logger;
            _notyf = notyf;
        }

        public IActionResult Index()
        {
            _notyf.Error("Some Error Message");
            _notyf.Warning("Some Error Message");
            _notyf.Information("Information Notification - closes in 4 seconds.", 4);
            _notyf.Custom("Custom Notification - closes in 6 seconds.", 6, "whitesmoke", "fa fa-gear");
            _notyf.Custom("Custom Notification - closes in 8 seconds.", 8, "#B600FF", "fa fa-home");
            _notyf.Custom("Custom Notification for info - closes in 10 seconds.", 10, "#Ff0000", "fa fa-info");
            _notyf.Custom("Custom Notification - closes in 12 seconds.", 12, "#B600FF", "fa fa-warning");

            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}