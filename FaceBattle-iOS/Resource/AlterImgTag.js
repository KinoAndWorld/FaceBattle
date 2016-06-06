function setImageClickFunction(){
    var imgs = document.getElementsByTagName("img");
    for(var i=0;i<imgs.length;i++) {
        imgs[i].setAttribute("onClick","getImg(src)");
    }
}

function getImg(src){
    var rect = getImageRect(src);
    
    var url = src + "m&&&y" + rect;
    
    console.log(rect);
    console.log(url);
    
    document.location = url;
}

function getImageRect(src){
    var imgs = document.getElementsByTagName("img");
    
    var foundImg;
    for(var i=0;i<imgs.length;i++) {
        if (imgs[i].src == src){
            foundImg = imgs[i];
            break;
        }
    }
    
    var rect;
    rect = foundImg.getBoundingClientRect().left+"::";
    rect = rect+imgs[i].getBoundingClientRect().top+"::";
    rect = rect+imgs[i].width+"::";
    rect = rect+imgs[i].height;
    return rect;
}
