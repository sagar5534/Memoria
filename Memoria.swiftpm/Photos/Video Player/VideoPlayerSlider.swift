import SwiftUI

struct VideoPlayerSlider: View {
    @EnvironmentObject var playerVM: VideoPlayerModel

    var body: some View {
        HStack {
            
            Button(action: {
                playerVM.isPlaying ? playerVM.player.pause() : playerVM.player.play()
            }, label: {
                Image(systemName: playerVM.isPlaying ? "pause.circle" : "play.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
            })
            .foregroundColor(.white)
            .padding(.horizontal)
            .contentShape(Rectangle())

            Slider(value: $playerVM.currentTime, in: 0 ... (playerVM.duration ?? .infinity), onEditingChanged: { isEditing in
                    playerVM.isEditingCurrentTime = isEditing
                })
                .foregroundColor(.white)
                .accentColor(.white)
                .padding(.trailing)
            
        }
    }
}
