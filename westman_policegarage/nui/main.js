let currentVehicle = ""; 

function updateCurrentVehicle(hash) {
  currentVehicle = hash;
}

function OpenPopUp(hash) {
  popup.style.visibility = 'visible';
  updateCurrentVehicle(hash); 
}

window.addEventListener('DOMContentLoaded', () => {

  const background = document.getElementById('background');
  const popup = document.getElementById('popup');
  popup.style.visibility = 'hidden';
  background.style.visibility = 'hidden';

  window.addEventListener('message', (event) => {
    let data = event.data;
    if (data.action === 'open') {
      background.style.visibility = 'visible';
    } else if (data.action === 'close') {
      background.style.visibility = 'hidden';
    }
  });

  const CloseButton = document.getElementById('exit-button');
  CloseButton.addEventListener('click', () => {
    fetch('https://westman_policegarage/exit');
  });

  const YesPopUpButton = document.getElementById('popup-button-yes');
  const NoPopUpButton = document.getElementById('popup-button-no');

  NoPopUpButton.addEventListener('click', () => {
    ClosePopUp();
  });


 
  window.addEventListener('message', function(event) {
    if (event.data.action === 'sendData') {
     
      var garageVehiclesData = JSON.parse(event.data.data);

      let productsHTML = '';
   
      for (var key in garageVehiclesData) {
        if (garageVehiclesData.hasOwnProperty(key)) {
          var vehicle = garageVehiclesData[key];
          productsHTML += `
            <div id="individual">
              <div>
                <div id="header-title">
                  ${vehicle.name}
                </div>
                <img src="${vehicle.img}" id="image">
                <p id="speed-paragraph">${vehicle.speed}</p>
                <button id="openPopUp-button" onclick="OpenPopUp('${vehicle.hash}')">Spawn</button>
              </div>
            </div>
          `;
        }
      }
      const grid = document.getElementById('grid-container')
      grid.innerHTML = productsHTML;
    }
  });



  

  YesPopUpButton.addEventListener('click', () => {
    const hash = currentVehicle; 
    ClosePopUp();
    console.log("Hash before sending:", hash); 
    var CarData = JSON.stringify(hash); 
    console.log("jsonString before sending:", CarData); 
  
    fetch('https://westman_policegarage/spawnvehicle', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: CarData 
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Failed to spawn vehicle');
      }
    })
    .catch(error => {
    });
  });
  
  

  function ClosePopUp() {
    popup.style.visibility = 'hidden';
  }

});

