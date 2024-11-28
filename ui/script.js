window.addEventListener('DOMContentLoaded', () => {
    const blackshopUI = document.getElementById('blackshop');
    if (blackshopUI) {
        blackshopUI.style.display = 'none';
    }
});

window.addEventListener('message', function (event) {
    const blackshopUI = document.getElementById('blackshop');
    const itemsContainer = document.getElementById('items');

    if (!blackshopUI || !itemsContainer) {
        console.error("UI error");
        return;
    }

    if (event.data.action === 'open') {
        blackshopUI.style.display = 'block';
        itemsContainer.innerHTML = '';

        if (Array.isArray(event.data.items)) {
            event.data.items.forEach(item => addItemToUI(item));
        } else {
            console.error('Items error');
        }
    }

    if (event.data.action === 'close') {
        blackshopUI.style.display = 'none';
    }
});

document.getElementById('close')?.addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/closeShop`, { method: 'POST' })
});

function handleItemClick(item) {
    if (!item || typeof item.itemKey === 'undefined' || typeof item.price === 'undefined') {
        return;
    }

    fetch(`https://${GetParentResourceName()}/buyItem`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ itemKey: item.itemKey, price: item.price }) 
    })
    .then(response => response.json())
    fetch(`https://${GetParentResourceName()}/closeShop`, { method: 'POST' })

}

function addItemToUI(item) {
    console.log(`Creating UI for ${item.name}, Image URL: ${item.imageUrl}`);
    const itemsContainer = document.getElementById('items');

    const itemDiv = document.createElement('div');
    itemDiv.classList.add('item');

    const itemImgDiv = document.createElement('div');
    itemImgDiv.classList.add('itemImgDiv');

    const itemImage = document.createElement('img');
    itemImage.src = item.imageUrl;
    itemImage.alt = item.name;
    itemImage.style.width = '100px';
    itemImage.style.height = '100px';
    itemImage.classList.add('itemImage');

    const itemName = document.createElement('span');
    itemName.textContent = item.name;
    itemName.classList.add('itemName');

    const itemPrice = document.createElement('span');
    itemPrice.textContent = `$${item.price}`;
    itemPrice.classList.add('itemPrice');

    itemImgDiv.appendChild(itemImage);
    itemImgDiv.appendChild(itemName);

    itemDiv.appendChild(itemImgDiv);
    itemDiv.appendChild(itemPrice);

    itemDiv.onclick = () => handleItemClick(item);

    itemsContainer.appendChild(itemDiv);
}

