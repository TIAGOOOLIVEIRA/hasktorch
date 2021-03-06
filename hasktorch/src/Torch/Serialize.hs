module Torch.Serialize where

import qualified Torch.Internal.Managed.Serialize as S
import Torch.Tensor
import Torch.Internal.Cast
import Torch.NN
import Torch.Autograd

save :: [Tensor] -> FilePath -> IO ()
save inputs file = cast2 S.save inputs file

load :: FilePath -> IO [Tensor]
load file = cast1 S.load file

saveParams :: Parameterized f => f -> FilePath -> IO ()
saveParams model filePath = do 
    let params =  map toDependent $ flattenParameters model
    save params filePath

loadParams :: Parameterized b => b -> FilePath -> IO b
loadParams model filePath = do
    tensors <- load filePath
    let params = map IndependentTensor tensors
    pure $ replaceParameters model params
