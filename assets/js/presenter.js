import { tns } from "tiny-slider";

export class Presenter {
  constructor(context) {
    this.context = context;
    this.currentPage = parseInt(context.el.dataset.currentPage);
    this.maxPage = parseInt(context.el.dataset.maxPage);
    this.hash = context.el.dataset.hash;
  }

  init(refresh = false) {
    if (this.slider) {
      try {
        if (typeof this.slider.destroy === "function") {
          this.slider.destroy();
        }
      } catch (e) {
        console.error("Error destroying slider", e);
      }
    }

    const container = document.querySelector("#slider");
    if (!container || container.children.length === 0) return;

    this.slider = tns({
      container: "#slider",
      items: 1,
      mode: "gallery",
      slideBy: "page",
      center: true,
      autoplay: false,
      controls: false,
      swipeAngle: false,
      startIndex: this.currentPage,
      speed: 0,
      loop: false,
      nav: false,
    });

    if (refresh) {
      return;
    }

    this.pageHandler = (data) => {
      //set current page
      if (this.currentPage == data.current_page) {
        return;
      }

      this.currentPage = parseInt(data.current_page);
      if (this.slider && this.slider.goTo) {
        this.slider.goTo(data.current_page);
      }
    };

    this.chatVisibleHandler = (data) => {
      const wrapper = document.getElementById("post-list-wrapper");
      if (!wrapper) return;

      if (data.value) {
        wrapper.classList.remove("animate__animated", "animate__fadeOutLeft");
        wrapper.classList.add("animate__animated", "animate__fadeInLeft");
      } else {
        wrapper.classList.remove("animate__animated", "animate__fadeInLeft");
        wrapper.classList.add("animate__animated", "animate__fadeOutLeft");
      }
    };

    this.pollVisibleHandler = (data) => {
      const el = document.getElementById("poll");
      if (!el) return;
      if (data.value) {
        el.classList.remove("animate__animated", "animate__fadeOut");
        el.classList.add("animate__animated", "animate__fadeIn");
      } else {
        el.classList.remove("animate__animated", "animate__fadeIn");
        el.classList.add("animate__animated", "animate__fadeOut");
      }
    };

    this.joinScreenVisibleHandler = (data) => {
      const el = document.getElementById("joinScreen");
      if (!el) return;
      if (data.value) {
        el.classList.remove("animate__animated", "animate__fadeOut");
        el.classList.add("animate__animated", "animate__fadeIn");
      } else {
        el.classList.remove("animate__animated", "animate__fadeIn");
        el.classList.add("animate__animated", "animate__fadeOut");
      }
    };

    this.keyupHandler = (e) => {
      if (e.target.tagName.toLowerCase() != "input") {
        switch (e.key) {
          case "f": // F
            e.preventDefault();
            this.fullscreen();
            break;
          case "ArrowLeft":
            e.preventDefault();
            if (window.opener) {
              window.opener.dispatchEvent(
                new KeyboardEvent("keydown", { key: "ArrowLeft" })
              );
            }
            break;
          case "ArrowRight":
            e.preventDefault();
            if (window.opener) {
              window.opener.dispatchEvent(
                new KeyboardEvent("keydown", { key: "ArrowRight" })
              );
            }
            break;
        }
      }
    };

    this.storageHandler = (e) => {
      if (e.key == "slide-position") {
        this.currentPage = parseInt(e.newValue);
        if (this.slider && this.slider.goTo) {
          this.slider.goTo(e.newValue);
        }
      }
    };

    this.context.handleEvent("page", this.pageHandler);
    this.context.handleEvent("chat-visible", this.chatVisibleHandler);
    this.context.handleEvent("poll-visible", this.pollVisibleHandler);
    this.context.handleEvent("join-screen-visible", this.joinScreenVisibleHandler);

    window.addEventListener("keyup", this.keyupHandler);
    window.addEventListener("storage", this.storageHandler);
  }

  update() {
    this.init(true);
  }

  destroy() {
    window.removeEventListener("keyup", this.keyupHandler);
    window.removeEventListener("storage", this.storageHandler);
    if (this.slider) {
      try {
        if (typeof this.slider.destroy === "function") {
          this.slider.destroy();
        }
      } catch (e) {
        console.error("Error destroying slider during hook destruction", e);
      }
    }
  }

  fullscreen() {
    var docEl = document.getElementById("presenter");
    if (!docEl) return;

    try {
      if (docEl.webkitRequestFullscreen) {
        docEl.webkitRequestFullscreen();
      } else if (docEl.requestFullscreen) {
        docEl.requestFullscreen();
      } else if (docEl.mozRequestFullScreen) {
        docEl.mozRequestFullScreen();
      }
    } catch (e) {
      console.error("Fullscreen failed", e);
    }
  }
}
