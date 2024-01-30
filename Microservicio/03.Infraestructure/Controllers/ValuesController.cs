using Microservicio._01.Domain.Models.Dtos;
using Microservicio._01.Domain.Models.Entities;
using Microservicio.Application.Business.Contracts;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Net.Mime;

namespace Microservicio.Infraestructure.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController : ControllerBase
    {
        private readonly IValidationBusiness _validationBusiness;

        public ValuesController(IValidationBusiness validationBusiness)
        {
            _validationBusiness = validationBusiness;
        }

        [HttpPost("ValidationProcess"), Consumes(MediaTypeNames.Application.Json), Produces(MediaTypeNames.Application.Json)]
        public async Task<ActionResult<ResultDto>> ValidateModel([FromBody] RequestDto request)
        {
            ResultDto result = await _validationBusiness.ValidateProcess(request);

            if (!result.Success)
                return StatusCode((int)HttpStatusCode.NotFound, result);

            return StatusCode((int)HttpStatusCode.OK, result);
        }

        [HttpGet]
        [Route("Index")]
        public IActionResult Index()
        {
            string baseUri = $"{HttpContext.Request.Scheme}://{HttpContext.Request.Host.Value}/";
            string completeUrl = $"{baseUri}swagger";
            string nombreWebApi = "WebApi.Plantillas.Microservice";

            string html = @"
                <!DOCTYPE html>
                <html lang='en'>
                <head>
                  <title>" + nombreWebApi + @"</title>
                  <meta charset='utf-8'>
                  <meta name='viewport' content='width=device-width, initial-scale=1'>
                  <link rel='icon' href='https://cdn4.iconfinder.com/data/icons/file-extension-names-vol-8/512/24-512.png'>
                  <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css'>
                  <style>
                    body {
                      background-color: #EFEFEF;
                      font-family: Arial, sans-serif;
                    }
                    h1 {
                      color: #FF0000;
                      text-align: left;
                      margin-top: 50px;
                      margin-bottom: 20px;
                    }
                    .label-success, .label-default, .label-warning {
                      padding: 5px 10px;
                      margin: 5px;
                      font-size: 18px;
                      font-weight: bold;
                      text-shadow: 1px 1px 1px rgba(0,0,0,0.5);
                      border-radius: 4px;
                    }
                    .label-success {
                      background-color: #FF0000;
                    }
                    .label-default {
                      background-color: #000000;
                      color: #FFFFFF;
                    }
                    .label-warning {
                      background-color: #CCCCCC;
                      color: #000000;
                    }
                    a {
                      color: #FF0000;
                    }
                  </style>
                </head>
                <body>
                  <div class='container-fluid'>
                    <div class='form-group'>
                      <h1>" + nombreWebApi + @"</h1>
                      <div>
                        <span class='label label-success'>v1.0</span>
                        <span class='label label-warning'>Web Api</span>
                      </div>
                    </div>
                    <div class='form-group'>";

            #if DEBUG
                        html = html + @"<p>[Documentación] : <a href='" + completeUrl + "' target='_blank'>Swagger UI</a></p>";
            #endif

            html = html + @"</div>
                  </div>
                </body>
                </html>";

            return Content(html, "text/html");
        }
    }
}